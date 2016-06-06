class CodapBaseObject
    SINGLE_TEXT_DIALOG_TEXTFIELD = {css: '.dg-single-text-dialog-textfield'}
    SINGLE_TEXT_DIALOG_OK_BUTTON = {css: '.dg-single-text-dialog-ok'} #Graph Screenshot, Display Webpage
    SINGLE_TEXT_DIALOG_CANCEL_BUTTON = {css: '.dg-single-text-dialog-cancel'}
    GRAPH_TILE = {css: '.graph-view'}
    GRAPH_H_AXIS = {css: '.h-axis'}
    GRAPH_V_AXIS = {css: '.v-axis'}
    GRAPH_V2_AXIS = {css: '.v2-axis'}
    GRAPH_PLOT_VIEW = {css: '.plot-view'}
    GRAPH_LEGEND = {css: '.legend-view'}
    MAP_VIEW = {css: '.leaflet-map-pane'}
    MAP_lEGEND = {css: '.legend-view'}

    attr_reader :driver

    def initialize(driver)
      @driver = driver
    end

    def visit(url='/')
      driver.get(ENV['base_url'] + url)
    end

    def find(locator)
      driver.find_element locator
    end

    def clear(locator)
      find(locator).clear
    end

    def type(locator, input)
      find(locator).send_keys input
    end

    def click_on(locator)
      find(locator).click
    end

    def displayed?(locator)
      driver.find_element(locator).displayed?
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end

    def text_of(locator)
      find(locator).text
    end

    def title
      driver.title
    end

    def wait_for(seconds=5)
      Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
    end

    def switch_to_dialog
      user_entry_dialog = find(USER_ENTRY_DIALOG)
      driver.switch_to.alert(user_entry_dialog)
    end

    def select_menu_item(menu, menu_item)
      puts 'in select_menu_item'
      find(menu)
      wait_for {displayed? (menu_item)}
      click_on(menu_item)
    end

    def get_column_header(header_name)
      header_name_path = '//span[contains(@class, "slick-column-name") and text()="'+header_name+'"]'
      column_header_name = {xpath: header_name_path}
      column_header_name_loc = find(column_header_name)
      driver.action.move_to(column_header_name_loc).perform
      puts "Column header name is #{column_header_name_loc.text}"
      return column_header_name_loc
    end

    def drag_attribute(source_element, target_element)
      #drag_scroller
      #drag_scroller_right
      source_loc = get_column_header(source_element)
      case (target_element)
        when 'x'
          target_loc = find(GRAPH_H_AXIS)
        when 'y'
          target_loc = find(GRAPH_V_AXIS)
        when 'graph_legend'
          target_loc = find(GRAPH_PLOT_VIEW)
          wait_for { displayed?(GRAPH_LEGEND)}
        when 'map_legend'
          target_loc = find(MAP_LEGEND)
      end
      driver.action.drag_and_drop(source_loc, target_loc).perform
    end

  end
end