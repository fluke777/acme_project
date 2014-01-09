GoodData::Model::ProjectBuilder.create("gooddata-ruby test #{Time.now.to_i}") do |p|

  p.add_dataset("payments") do |d|
    d.add_attribute("division")
    d.add_attribute("user")
    d.add_fact("amount")
  end

  p.upload("https://gist.github.com/fluke777/8283787/raw/e7830ea66352e488e1ffc128fb71b28b6f38e2ef/test_data.csv", :dataset => 'payments')

  p.add_metric('Sum Amount', :expression => 'SELECT SUM(#"amount")', :extended_notation => true)  
  p.add_metric('Count Division', :expression => 'SELECT COUNT(@"division")', :extended_notation => true)  
  
  p.add_report("My first report",
    :left => [
      'division',
      {:type => :metric, :title => "Sum Amount"}
    ])

  p.add_report("My second report",
    :left => [
      {:type => :metric, :title => "Count Division"}
    ])

  p.add_dashboard("A dash of stuff") do |d|
    d.add_tab("Tab") do |t|
      t.add_report(:title => "My first report", :position_x => 0)
      t.add_report(:title => "My second report", :position_x => 200)
    end
  end

  p.assert_report({:left => 'user', :top => [{:type => :metric, :title => "Sum Amount"}]},
    [["Petr", "Tomas"], ["2", "2"]])
end