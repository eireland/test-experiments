class CodapTableObject< CodapBaseObject

H_SCROLLER = {css: '.sc-horizontal, .sc-scroller-view'}
SCROLL_H_RIGHT = {css: '.thumb'}
CASE_TABLE_TILE = {css: '.dg-case-table'}
ATTRIBUTE_NAME = {css: '.slick-header-column'}
TABLE_TRASH = {css:  '.table-trash'}
TABLE_DROP_TARGET = {css: '.dg-table-drop-target'}
TABLE_ATTRIBUTES = {css: '.table-attributes'} #Tool palette icon for creating new attributes and export cases
TABLE_ATTRIBUTES_MENU = {css:  '.attributes-popup'}

# Need to add menu items for trash and attributes menu

def initialize(driver)
  super
end

def get_column_header(header_name)
  header_name_path = '//span[contains(@class, "slick-column-name") and text()="'+header_name+'"]'
  column_header_name = {xpath: header_name_path}
  column_header_name_loc = driver.find_element(column_header_name)
  driver.action.move_to(column_header_name_loc).perform
  puts "Column header name is #{column_header_name_loc.text}"
  return column_header_name_loc
end

def drag_scroller
  scroll = driver.find_element(H_SCROLLER)
  driver.action.drag_and_drop_by(scroll, 100, 0).perform
end

def drag_scroller_right
  puts "In drag_scroller_right"
  scroll_right = driver.find_element(SCROLL_H_RIGHT)
  puts "Found element #{scroll_right}"
  driver.action.drag_and_drop_by(scroll_right, 50, 0).perform
  #scroll_right.click
end


end