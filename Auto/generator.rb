require 'erb'
require 'json'
require 'fileutils'

class AutoGenerator
  attr_accessor :data_hash

  def initialize()
    file = File.read(File.join(__dir__,"test_cases.json"))
    @data_hash = JSON.parse(file)
  end

  def parse_file
    @data_hash['selections'].each do |selection, index|
      create_selection_directory(selection)
      selection['test_cases'].each_with_index do |test_case, index|
        test_case_generator = TestCasesTemplate.new()
        test_case_generator.selection_id = selection['selection_id']
        test_case_generator.test_number = index + 1
        test_case_generator.total_test_cases = selection['test_cases'].size
        test_case_generator.test_name = selection['test_name']
        test_case_generator.expected_json = test_case['expected_json']
        test_case_generator.condition_fields = test_case['condition_fields']
        test_case_generator.geography = selection['geography']
        test_case_generator.drug_class = selection['drug_class']
        test_case_generator.state_list = selection['state_list']
        test_case_generator.plan_list = selection['plan_list']
        test_case_generator.drug_list = selection['drug_list']
        test_case_generator.function_name = @data_hash['function_folder_name']
        test_case_generator.tab_name = @data_hash['tab_folder_name']
        test_case_generator.validation_fields = @data_hash['validation_fields']
        test_case_generator.save(File.join(selection_path(selection), "#{test_case_generator.test_number_formated}_validate_data.sql"), :test_case_template)
        test_case_generator.save(File.join(common_selection_path(selection), "test_001_0#{test_case_generator.total_test_cases_formated}_validate_data.sql"), :common_template)
        test_case_generator.save(File.join(report_row_path(selection), "validate_#{test_case_generator.function_name}_report_row.sql"), :report_row_template)
      end
    end
  end

  def create_selection_directory(selection)
    FileUtils.mkdir_p(common_selection_path(selection))
    FileUtils.mkdir_p(report_row_path(selection))
  end

  def report_row_path(selection)
    File.join(base_selection_path(selection), 'common_front_end')
  end

  def common_selection_path(selection)
    File.join(selection_path(selection),'common_front_end')
  end

  def selection_path(selection)
    File.join(base_selection_path(selection),selection['selection_name'])
  end

  def base_selection_path(selection)
    File.join(File.expand_path("../../Analytics/scripts/report_data/#{@data_hash['function_folder_name']}/#{@data_hash['tab_folder_name']}/selection", __FILE__))
  end

end

class TestCasesTemplate
  include ERB::Util
  attr_accessor :selection_id, :condition_fields,
                :test_number, :total_test_cases,
                :test_name, :expected_json, :geography,
                :drug_class, :state_list, :plan_list,
                :drug_list, :function_name, :validation_fields,
                :tab_name

  def complete_function_name
    "#{function_name}_#{tab_name}"
  end

  def test_number_formated
    @test_number.to_i > 10 ? "0#{@test_number}" : "00#{@test_number}"
  end

  def total_test_cases_formated
    @total_test_cases.to_i > 10 ? @total_test_cases : "0#{@total_test_cases}"
  end  

  def format_array list
    list.empty? ? 'ARRAY[]::varchar[]' : 'ARRAY[' + list.split(',').map{ |element| "'#{element}'" }.join(',') + ']'
  end

  def conditional_fields_formatted
    condition_fields.keys.map{ |element| "#{element}=''' || #{element} || ''' " }.join('AND ')
  end

  def save(file, template_name)
    File.open(file, "w+") do |f|
      erb = ERB.new(self.send(template_name)).result(binding)
      f.write(erb)
    end
  end

  def test_case_template()
%{CREATE OR REPLACE FUNCTION <%= test_name %>_selection_<%= selection_id %>_test_<%= test_number_formated %>_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  <% condition_fields.each do |field_name, field_value| %>
  <%= field_name %> varchar := '<%= field_value %>';
  <% end %>
BEGIN

expected_value = format('[<%= expected_json %>]', <%= condition_fields.keys.join(', ') %>);

PERFORM <%= test_name %>_selection_<%= selection_id %>_test_01_<%= total_test_cases_formated %>_validate_data(expected_value,'<%= test_number_formated %>', <%= condition_fields.keys.join(', ') %>);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;}
  end

  def common_template()
%{CREATE OR REPLACE FUNCTION <%= test_name %>_selection_<%= selection_id %>_test_01_<%= total_test_cases_formated %>_validate_data(expected_value varchar, test_number varchar, <%= condition_fields.keys.join(' varchar, ') %> varchar)
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(<%= format_array(state_list) %>, <%= format_array(plan_list) %>, <%= format_array(drug_list) %>,'<%= geography %>','<%= drug_class %>') INTO criteria_report_id;
PERFORM ana_<%= complete_function_name %>_validate_report_row(expected_value, test_number, <%= condition_fields.keys.join(', ') %>, criteria_report_id);

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;}
  end

  def report_row_template()
%{CREATE OR REPLACE FUNCTION ana_<%= complete_function_name %>_validate_report_row(expected_value varchar, test_number varchar, <%= condition_fields.keys.join(' varchar, ') %> varchar, criteria_report_id integer)
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

end

generator = AutoGenerator.new()
generator.parse_file