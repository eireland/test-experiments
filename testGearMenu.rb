#! /usr/bin/ruby

require 'rspec'
require 'selenium-webdriver'
require 'optparse'
require 'date'
require 'csv'

#Closes browser at end of test
def teardown
  @browser.quit
end

#Main function
def run
  setup
  yield
  teardown
end

#Find the parent component
def find_parent(component)
  parent = component.find_element(:xpath=>'.')
end

#Find the gear menu in a parent component
def find_gear_menu(parent)
  gear_menu=@wait.until{parent.find_element(:css=>'.dg-gear-view')}
  parent_text=parent.text
  gear_menu_parent = find_parent(gear_menu)
  if !gear_menu
    puts "No gear menu"
  else
    gear_menu.click
    puts 'Clicked on gear menu'
    find_gear_menu_item("Show Count")
  end
end

#Find the gear menu item in a parent component
def find_gear_menu_item(menu_item)
  menu_items=@wait.until{@browser.find_elements(:css=>'a.menu-item')}
  menu_item_choice=menu_items.find{|name| name.text==menu_item}
  puts "Menu item name is #{menu_item_choice.text}"
  menu_item_choice.click
end

def find_status(parent)
  puts "In table find_status"
  table_title = @wait.until{parent.find_element(:css=>'.dg-title-view')}
  puts "Table title: #{table_title.text}"

  table_status = @wait.until{parent.find_element(:css=>'div.dg-status-view')}
  puts "Table status: #{table_status.text}"
end

def find_component(component)
  @browser.switch_to.default_content # Always switch to main document when looking for a certain component
  component_views=@browser.find_elements(:css=>'div.component-view')
  component_title=component_views.find{|title| title.find_element(:css=>'div.dg-title-view').text==component}
  puts "Component wanted is #{component}"
  component_title_text = component_title.text
  puts "Component found is #{component_title_text}"
  if component_title!=""
    @parent = find_parent(component_title)
    case component
      when 'Graph'
        find_gear_menu(@parent)
      when 'Performance Harness'
        puts "In Performance Harness"
      #find_gear_menu(@parent)
    end
  end
end