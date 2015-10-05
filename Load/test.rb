require 'erb'

def get_template()
  %{
CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_<%= selection_id %>_test_<%= test_number %>_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := '<%= drug_name %>';
  qualifier varchar := '<%= qualifier_name %>';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":1341,"health_plan_count":1,"total_health_plan_count":20}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_<%= selection_id %>_test_01_<%= total_test_cases %>_validate_data(expected_value,<%= test_number %>, drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
  }
end

class ShoppingList
  include ERB::Util
  attr_accessor :selection_id, :drug_name, :qualifier_name, :test_number, :total_test_cases, :template, :date

  def initialize(template, date=Time.now)
    @date = date
    @selection_id = 1
    @drug_name = 'DRUG_001'
    @qualifier_name = 'ST'
    @test_number = '001'
    @total_test_cases = '21'
    @template = template
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end

end

list = ShoppingList.new(get_template)
list.save(File.join('/Users/ignacio/Documents/analytics/repos/data-warehouse-storeprocedures-tests/Load', 'list.html'))