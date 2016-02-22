class CODAPObject

  SPLASHSCREEN = {css: '.focus'}
  DATA_INTERACTIVE = { css: 'iframe'}
  DOC_TITLE = {css: '.doc-title'}
  FILE_MENU = { css: '.nav-popup-button'}
  TOOLSHELF_BACK = { css: '.toolshelf-background'}
  MENU_SEPARTOR = { css: '.sc-menu-item.disabled'}
  TABLE_BUTTON = { css: '.dg-table-button' }
  GRAPH_BUTTON = { css: '.dg-graph-button'  }
  MAP_BUTTON = {css: '.dg-map-button'}
  SLIDER_BUTTON = {css: '.dg-slider-button' }
  CALC_BUTTON = {css: '.dg-calc-button' }
  TEXT_BUTTON = {css: '.dg-text-button' }
  UNDO_BUTTON = {css: '.dg-undo-button' }
  REDO_BUTTON = {css: '.dg-redo-button' }
  TILE_LIST_BUTTON ={css: '.dg-tilelist-button' }
  OPTION_BUTTON = {css: '.dg-option-button' }
  GUIDE_BUTTON   = {css: '.dg-guide-button' }
  HELP_BUTTON = {css: '.moonicon-icon-help'}
  H_SCROLLER = {css: '.sc-horizontal, .sc-scroller-view'}
  SCROLL_H_RIGHT = {css: '.thumb'}
  CASE_TABLE_TILE = {css: '.dg-case-table'}
  TABLE_HEADER_NAME = {css: '.slick-column-name'}
  GRAPH_TILE = {css: '.graph-view'}
  GRAPH_H_AXIS = {css: '.h-axis'}
  GRAPH_V_AXIS = {css: '.v-axis'}
  GRAPH_PLOT_VIEW = {css: '.plot-view'}
  GRAPH_LEGEND = {css: '.legend-view'}
  MAP_TILE = {css: '.leaflet-container'}
  SLIDER_TILE = {css: '.slider-thumb'}
  TEXT_TILE = {css: '.text-area'}
  CALC_TILE = {css: '.calculator'}
  OPEN_NEW_BUTTON = {id: 'dg-user-entry-new-doc-button'}
  OPEN_EXAMPLE_BUTTON = {id: 'dg-user-entry-example-button'}
  OPEN_LOCAL_DOC_BUTTON = {id: 'dg-user-entry-open-local-doc-button'}
  USER_ENTRY_OK_BUTTON= {css: '.dg-ok-new-doc-button'}
  USER_ENTRY_EXAMPLE_OK_BUTTON = {css: '.dg-example-ok-button'}
  EXAMPLE_FILENAME_LIST  = {css: '.dg-example-name'}
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  OPEN_LOCAL_DOC_SELECT = {xpath: '//div[contains(@class, "dg-file-import-view")]/div/input[contains(@class, "field")]'}#= {css: '.dg-file-import-view'}
  USER_ENTRY_OPEN_LOCAL_OK = {css: '.dg-ok-open-local-button'}
  LOCAL_FILE_SELECT = {css: '.dg-file-import-view, .not-empty'}
  FILE_MENU_OPEN_DOC = {id: 'dg-fileMenutItem-open-doc'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert)]/div/div/div[contains(@label,"Close")]'}


  attr_reader :driver

  def initialize(driver)
    @driver = driver
    visit
    verify_page
    dismiss_splashscreen
  end

  def visit
    driver.get ENV['base_url']
  end

  def open_file_menu
    driver.find_element(FILE_MENU).click
  end

  def select_file_menu_open_doc
    wait_for {displayed?(FILE_MENU_OPEN_DOC)}
    driver.find_element(FILE_MENU_OPEN_DOC).click
  end

  def not_saved_alert_close_button
    wait_for {displayed?(ALERT_DIALOG)}
    wait_for {displayed?(NOT_SAVED_CLOSE_BUTTON)}
    driver.find_element(NOT_SAVED_CLOSE_BUTTON).click
  end

  def start_new_doc
    puts "In start_new_doc"
    wait_for { displayed?(OPEN_NEW_BUTTON) }
    driver.find_element(OPEN_NEW_BUTTON).click
    wait_for { displayed?(USER_ENTRY_OK_BUTTON) }
    driver.find_element(USER_ENTRY_OK_BUTTON).click
    #dismissed? verify_dismiss of user entry
  end

  def open_sample_doc(sample_doc_name)
    doc_path = '//div[contains(@class, "dg-example-name") and text()="'+sample_doc_name+'"]'
    sample_doc = {xpath: doc_path}
    puts "In open_example_doc"
    wait_for { displayed?(OPEN_EXAMPLE_BUTTON) }
    driver.find_element(OPEN_EXAMPLE_BUTTON).click
    puts "clicked example button"
    wait_for { displayed?(EXAMPLE_FILENAME_LIST) }
    select_menu_item(EXAMPLE_FILENAME_LIST, sample_doc)
    driver.find_element(USER_ENTRY_EXAMPLE_OK_BUTTON).click
    #dismissed? verify_dismiss of user entry
  end

  def open_local_doc(doc_name)
    puts "In open_local_doc"
    wait_for { displayed?(OPEN_LOCAL_DOC_BUTTON)}
    driver.find_element(OPEN_LOCAL_DOC_BUTTON).click
    puts "clicked open local doc. doc name is #{doc_name}"
    wait_for { displayed?(OPEN_LOCAL_DOC_SELECT)}
    driver.find_element(OPEN_LOCAL_DOC_SELECT).send_keys doc_name
    wait_for {displayed? (LOCAL_FILE_SELECT)}
    wait_for {displayed? (USER_ENTRY_OPEN_LOCAL_OK)}
    driver.find_element(USER_ENTRY_OPEN_LOCAL_OK).click
  end

  def verify_doc(opened_doc)
    puts "open_doc is #{opened_doc}"
    doc_title = driver.find_element(DOC_TITLE)
    puts "Doc title is #{doc_title.text} opened_doc is #{opened_doc}"
    wait_for {doc_title.text == opened_doc}
    #expect(doc_title.text).to eql opened_doc
  end

  def click_table_button
    wait_for {displayed? (TABLE_BUTTON)}
    driver.find_element(TABLE_BUTTON).click
    verify_tile(TABLE_BUTTON)
  end

  def click_graph_button
    wait_for {displayed? (GRAPH_BUTTON)}
    driver.find_element(GRAPH_BUTTON).click
    verify_tile(GRAPH_BUTTON)
  end

  def click_map_button
    wait_for {displayed? (MAP_BUTTON)}
    driver.find_element(MAP_BUTTON).click
    verify_tile(MAP_BUTTON)
  end

  def click_slider_button
    wait_for {displayed? (SLIDER_BUTTON)}
    driver.find_element(SLIDER_BUTTON).click
    verify_tile(SLIDER_BUTTON)
  end

  def click_calc_button
    wait_for {displayed? (CALC_BUTTON)}
    driver.find_element(CALC_BUTTON).click
    verify_tile(CALC_BUTTON)
  end

  def click_text_button
    wait_for {displayed? (TEXT_BUTTON)}
    driver.find_element(TEXT_BUTTON).click
    verify_tile(TEXT_BUTTON)
  end

  def click_tilelist_button
    wait_for {displayed? (TILE_LIST_BUTTON)}
    driver.find_element(TILE_LIST_BUTTON).click
    verify_tile(TILE_LIST_BUTTON)
  end

  def click_option_button
    wait_for {displayed? (OPTION_BUTTON)}
    driver.find_element(OPTION_BUTTON).click
    verify_tile(OPTION_BUTTON)
    driver.find_element(MENU_SEPARTOR).click
  end

  def click_guide_button
    wait_for {displayed? (GUIDE_BUTTON)}
    driver.find_element(GUIDE_BUTTON).click
    verify_tile(GUIDE_BUTTON)
  end

  def click_toolshelf
    driver.find_element(TOOLSHELF_BACK).click
  end

  def get_column_header(header_name)
    header_name_path = '//span[contains(@class, "slick-column-name") and text()="'+header_name+'"]'
    column_header_name = {xpath: header_name_path}
    column_header_name_loc = driver.find_element(column_header_name)
    driver.action.move_to(column_header_name_loc).perform
    puts "Column header name is #{column_header_name_loc.text}"
    return column_header_name_loc
  end

  def drag_attribute(header_name, graph_target)
    #drag_scroller
    #drag_scroller_right
    source_loc = get_column_header(header_name)
    case (graph_target)
      when 'x'
        target_loc = driver.find_element(GRAPH_H_AXIS)
      when 'y'
        target_loc = driver.find_element(GRAPH_V_AXIS)
      when 'legend'
        target_loc = driver.find_element(GRAPH_PLOT_VIEW)
        wait_for { displayed?(GRAPH_LEGEND)}
    end
    driver.action.drag_and_drop(source_loc, target_loc).perform
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

  private
  def verify_page
    expect(driver.title).to eql('Untitled Document - CODAP')
  end


  def verify_tile(button)
    case (button)
      when TABLE_BUTTON
        #puts "Table button clicked"
        wait_for { displayed?(CASE_TABLE_TILE) }
      when GRAPH_TILE
        wait_for { displayed?(GRAPH_TILE) }
      when MAP_BUTTON
        wait_for { displayed?(MAP_TILE) }
      when SLIDER_BUTTON
        wait_for { displayed?(SLIDER_TILE) }
      when CALC_BUTTON
        wait_for { displayed?(CALC_TILE) }
      when TEXT_BUTTON
        wait_for { displayed?(TEXT_TILE) }
        driver.find_element(TEXT_TILE).click
      when TILE_LIST_BUTTON
        puts "Tile list button clicked"
      #driver.find_element(:xpath=> '//span[contains(@class, "ellipsis") and text()="No Data"]').click
      when OPTION_BUTTON
        puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
    end
  end

  def dismiss_splashscreen
    if !driver.find_element(SPLASHSCREEN) #Dismisses the splashscreen if present
      #sleep(5)
    else
      driver.find_element(SPLASHSCREEN).click
    end
  end

  def switch_to_dialog
    user_entry_dialog = driver.find_element(USER_ENTRY_DIALOG)
    driver.switch_to.alert(user_entry_dialog)
  end

  def wait_for(seconds=25)
    puts "Waiting"
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def select_menu_item(menu, menu_item)
    puts 'in select_menu_item'
    driver.find_element(menu)
    wait_for {displayed? (menu_item)}
    driver.find_element(menu_item).click
  end

  def displayed?(locator)
    driver.find_element(locator).displayed?
    puts "#{locator} found"
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "#{locator} not found"
    false
  end

end
