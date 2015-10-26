require 'erb'
require 'json'
require 'fileutils'
require 'securerandom'

class TestCasesGenerator
  attr_accessor :json_hash

  def initialize(file_name)
    file = File.read(File.join(__dir__,file_name))
    @json_hash = JSON.parse(file)
  end

  def parse_file
    parse_functions(@json_hash['functions'])
  end

  def parse_functions functions
    functions.each do |function|
      generator = TestCasesTemplate.new()
      generator.function_name = function['function_folder_name']
      generator.tab_name = function['tab_folder_name']
      generator.validation_fields = function['validation_fields']
      generator.condition_fields_data_types = function['condition_fields_data_types'].split(',')

      parse_selections(function['selections'], generator)
    end
  end

  def parse_selections(selections, generator)
    selections.each do |selection, index|

        generator.selection_id = selection['selection_id']
        generator.selection_name = selection['selection_name']
        generator.total_test_cases = selection['test_cases'].size
        generator.test_name = selection['test_name']
        generator.geography = selection['geography']
        generator.drug_class = selection['drug_class']
        generator.geo_list = selection['geo_list']
        generator.plan_list = selection['plan_list']
        generator.drug_list = selection['drug_list']
        file_generator = FilesGenerator.new(generator)
        file_generator.create_directories

        parse_test_cases(selection['test_cases'], generator, selection)
        file_generator.save_report_row_file
        file_generator.save_validate_data_file
    end
  end

  def parse_test_cases(test_cases, generator, selection)
    test_cases.each_with_index do |test_case, index|
      generator.test_number = index + 1
      generator.expected_json = test_case['expected_json']
      generator.condition_fields = test_case['condition_fields']
      
      file = FilesGenerator.new(generator)
      file.save_test_case_file
      file.save_ssis_test_case_file
    end
  end

end

class FilesGenerator
  attr_accessor :selection_id, :selection_name,
                :function_name, :tab_name, :template

  def initialize generator
    @selection_id = generator.selection_id
    @selection_name = generator.selection_name
    @function_name = generator.function_name
    @tab_name = generator.tab_name
    @template = generator
  end

  def save_test_case_file
    template.save(File.join(selection_path, test_case_file_name), :test_case_template)
  end
  
  def save_ssis_test_case_file
    template.save(File.join(__dir__, "#{function_name}_#{tab_name}.xml"), :ssis_executable_template, "a+")
  end

  def save_report_row_file
    template.save(File.join(report_row_path, report_row_file_name), :report_row_template)
  end

  def save_validate_data_file
    template.save(File.join(common_selection_path, common_validate_data_file_name), :common_template)
  end

  def test_case_file_name
    "#{template.test_name}_selection_#{selection_id}_test_#{template.test_number_formated}_validate_data.sql"
  end

  def common_validate_data_file_name
    "#{template.test_name}_selection_#{selection_id}_test_01_#{template.total_test_cases_formated}_validate_data.sql"
  end

  def report_row_file_name
    "ana_#{function_name}_#{tab_name}_validate_report_row.sql"
  end  

  def create_directories
    FileUtils.mkdir_p(common_selection_path)
    FileUtils.mkdir_p(report_row_path)
  end

  def report_row_path
    File.join(base_selection_path, 'common')
  end

  def common_selection_path
    File.join(selection_path,'common')
  end

  def selection_path
    File.join(base_selection_path,"#{selection_id} - #{selection_name}")
  end

  def base_selection_path
    File.join(File.expand_path("../../Analytics/Scripts/report_data/#{function_name}/#{tab_name}/selection", __FILE__))
  end

end

class TestCasesTemplate
  include ERB::Util
  attr_accessor :selection_id, :condition_fields, :selection_name,
                :test_number, :total_test_cases,
                :test_name, :expected_json, :geography,
                :drug_class, :geo_list, :plan_list,
                :drug_list, :function_name, :validation_fields,
                :tab_name, :condition_fields_data_types

  def complete_function_name
    "#{function_name}_#{tab_name}"
  end

  def test_number_formated
    @test_number.to_i >= 10 ? "0#{@test_number}" : "00#{@test_number}"
  end

  def total_test_cases_formated
    @total_test_cases.to_i >= 10 ? @total_test_cases : "0#{@total_test_cases}"
  end

  def format_array list
    list.empty? ? 'ARRAY[]::varchar[]' : 'ARRAY[' + list.split(',').map{ |element| "'#{element}'" }.join(',') + ']'
  end

  def conditional_fields_formatted
    condition_fields.keys.map{ |element| "#{element}=''' || #{element} || ''' " }.join('AND ')
  end

  def dynamic_json_fields_formatted
    result = []
    condition_fields.each_with_index do |element, index|
      result << "\"#{element[0]}\":#{"\"" if condition_fields_data_types[index] == 'varchar'}' || #{element[0]} || '#{"\"" if condition_fields_data_types[index] == 'varchar'}"
    end
    result.join(',')
  end

  def save(file, template_name, mode="w+")
    File.open(file, mode) do |f|
      erb = ERB.new(self.send(template_name)).result(binding)
      f.write(erb)
    end
  end

  def selection_name_formatted
    "Selection #{selection_id} - #{selection_name}"
  end

  def test_name_formatted
    "Test #{test_number_formated} #{function_name_formatted} #{tab_name.capitalize} Details"
  end

  def function_name_formatted
    function_name.gsub('rpt_','').split('_').map(&:capitalize).join(' by ')
  end

  def condition_fields_parameters
    condition_fields.keys.each_with_index.map { |field_name, index| "#{field_name} #{condition_fields_data_types[index]}" }.join(', ')
  end

  def test_case_template()
%{CREATE OR REPLACE FUNCTION <%= test_name %>_selection_<%= selection_id %>_test_<%= test_number_formated %>_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  <% condition_fields.each_with_index do |field, index| %>
    <%= field[0] %> <%= condition_fields_data_types[index]  %> := <%= "\'" if condition_fields_data_types[index] == 'varchar'  %><%= field[1] %><%= "\'" if condition_fields_data_types[index] == 'varchar'  %>;
  <% end %>
BEGIN

expected_value = '[{<%= dynamic_json_fields_formatted %>,<%= expected_json %>}]';

PERFORM <%= test_name %>_selection_<%= selection_id %>_test_01_<%= total_test_cases_formated %>_validate_data(expected_value,'<%= test_number_formated %>', <%= condition_fields.keys.join(', ') %>);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;}
  end

  def common_template()
%{CREATE OR REPLACE FUNCTION <%= test_name %>_selection_<%= selection_id %>_test_01_<%= total_test_cases_formated %>_validate_data(expected_value varchar, test_number varchar, <%= condition_fields_parameters %>)
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(<%= format_array(geo_list) %>, <%= format_array(plan_list) %>, <%= format_array(drug_list) %>,'<%= geography %>','<%= drug_class %>') INTO criteria_report_id;
PERFORM ana_<%= complete_function_name %>_validate_report_row(expected_value, test_number, <%= condition_fields.keys.join(', ') %>, criteria_report_id);

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;}
  end

  def report_row_template()
%{CREATE OR REPLACE FUNCTION ana_<%= complete_function_name %>_validate_report_row(expected_value varchar, test_number varchar, <%= condition_fields_parameters %>, criteria_report_id integer)
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  actual_value varchar;
  current_month_int INTEGER;
  report_select_columns varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;

report_select_columns  = '<%= validation_fields %>';
--Query the actual value
SELECT calculate_report_value_json(report_select_columns, get_report_name_call('<%= complete_function_name %>', ARRAY[criteria_report_id,current_month_int]), '<%= conditional_fields_formatted %>') INTO actual_value;

PERFORM validate_comparison_values_varchar(actual_value, expected_value,'ana_<%= complete_function_name %>_test_'|| test_number ||'_validate_data-error: EXPECTED FOR ROW RESULTS TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;}
  end

  def ssis_executable_template()
%{<DTS:Executable
      DTS:refId="Package\\Report <%= function_name_formatted %>\\<%= tab_name.capitalize %> Validation\\<%= selection_name_formatted %>\\<%= test_name_formatted %>, <%= selection_name_formatted %>"
      DTS:CreationName="Microsoft.SqlServer.Dts.Tasks.ExecuteSQLTask.ExecuteSQLTask, Microsoft.SqlServer.SQLTask, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
      DTS:Description="Execute SQL Task"
      DTS:DTSID="{<%= SecureRandom.uuid %>}"
      DTS:ExecutableType="Microsoft.SqlServer.Dts.Tasks.ExecuteSQLTask.ExecuteSQLTask, Microsoft.SqlServer.SQLTask, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
      DTS:LocaleID="-1"
      DTS:ObjectName="<%= test_name_formatted %>,<%= selection_name_formatted %>"
      DTS:TaskContact="Execute SQL Task; Microsoft Corporation; SQL Server 2012; © 2007 Microsoft Corporation; All Rights Reserved;http://www.microsoft.com/sql/support/default.asp;1"
      DTS:ThreadHint="">
      <DTS:Variables />
      <DTS:ObjectData>
        <SQLTask:SqlTaskData
          SQLTask:Connection="{CE1A9A1D-A669-49BA-9EC8-960DE1BB7D31}"
          SQLTask:SqlStatementSource="select <%= test_name %>_selection_<%= selection_id %>_test_<%= test_number_formated %>_validate_data()" xmlns:SQLTask="www.microsoft.com/sqlserver/dts/tasks/sqltask" />
      </DTS:ObjectData>
    </DTS:Executable>}
  end

end

unless ARGV.length == 1
  puts "Not the right number of arguments."
  puts "Usage: ruby generator.rb test_cases.json\n"
  exit
end

generator = TestCasesGenerator.new(ARGV[0])
generator.parse_file