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
        test_case_generator.save(File.join(selection_path(selection), "#{test_case_generator.test_number_formated}_validate_data.sql"))
      end
    end
  end

  def create_selection_directory(selection)
    FileUtils.mkdir_p(selection_path(selection))
  end

  def selection_path(selection)
    File.join(File.expand_path("../../Analytics/scripts/report_data/#{@data_hash['function_folder_name']}/#{@data_hash['tab_folder_name']}/selection/#{selection['selection_name']}", __FILE__))
  end

end

class TestCasesTemplate
  include ERB::Util
  attr_accessor :selection_id, :condition_fields,
                :test_number, :total_test_cases, :template, 
                :test_name, :expected_json

  def initialize
    @drug_name = 'DRUG_001'
    @qualifier_name = 'ST'
    @template = test_case_template
  end

  def test_number_formated
    @test_number.to_i > 10 ? "0#{@test_number}" : "00#{@test_number}"
  end

  def total_test_cases_formated
    @total_test_cases.to_i > 10 ? @total_test_cases : "0#{@total_test_cases}"
  end  

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
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

end

generator = AutoGenerator.new()
generator.parse_file