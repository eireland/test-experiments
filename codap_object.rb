require './codap_base_object'
require './cfm_object'

class CODAPObject < CodapBaseObject
  include CFMObject

  SPLASHSCREEN = {css: '.focus'}
  BACKGROUND = {css: 'menu-bar'}
  DATA_INTERACTIVE = { css: 'iframe'}
  DOC_TITLE = {css: '.menu-bar-content-filename'}
  DOC_FILE_STATUS = {css: 'span.menu-bar-file-status-alert'}
  FILE_MENU = { css: '.menu-anchor'}
  TOOLSHELF_BACK = { css: '.toolshelf-background'}
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
  HELP_BUTTON = {css: '.navBar-help'}
  VERSION_INFO = {css: 'span.menu-bar-info'}
  LOGIN_USER = {css: '.navBar-status'}
  H_SCROLLER = {css: '.sc-horizontal, .sc-scroller-view'}
  SCROLL_H_RIGHT = {css: '.thumb'}
  CASE_TABLE_TILE = {css: '.dg-case-table'}
  GRAPH_TILE = {css: '.graph-view'}
  MAP_TILE = {css: '.leaflet-container'}
  SLIDER_TILE = {css: '.slider-label'}
  TEXT_TILE = {css: '.text-area'}
  CALC_TILE = {css: '.calculator'}
#  OPEN_NEW_BUTTON = {id: 'dg-user-entry-new-doc-button'}
  OPEN_DOC_BUTTON = {id: 'dg-user-entry-open-doc-button'}
  AUTHORIZE_STARTUP_BUTTON = {id: 'dg-user-entry-authorize-startup-button'}
#HELP_TILE = {css: } Help is a webview in an iframe component has //*[div[contains(@class="titleview")and contains(text(), 'Help with CODAP')]
  TILE_ICON_SLIDER = {css: '.tile-icon-slider'}
  ALERT_DIALOG = {xpath: '//div[contains(@role, "alertdialog")]'}
  NOT_SAVED_CLOSE_BUTTON = {xpath: '//div[contains(@class, "sc-alert")]/div/div/div[contains(@label,"Close")]'}
  VIEW_WEBPAGE_MENU_ITEM = { id: 'dg-optionMenuItem-view_webpage'}
  OPTION_MENU_SEPARATOR ={css: '.menu-item.disabled'}
  OPEN_CODAP_WEBSITE = {id: 'dg-optionMenuItem-codap-website'}
  WEBVIEW_FRAME = {css: '.dg-web-view-frame'}
  TILE_MENU_ITEM = {css: 'a.menu-item'}

  def initialize()
    puts "Initializing"
  end

  def user_entry_open_doc
    puts "In user_entry_open_doc"
    wait_for{ displayed?(OPEN_DOC_BUTTON) }
    click_on(OPEN_DOC_BUTTON)
  end

  def user_entry_start_new_doc
    puts "In user_entry_start_new_doc"
    wait_for { displayed?(USER_ENTRY_NEW_DOC_BUTTON) }
    click_on(USER_ENTRY_NEW_DOC_BUTTON)
  end

  def open_file_menu
    click_on(FILE_MENU)
  end

  def not_saved_alert_close_button
    wait_for {displayed?(ALERT_DIALOG)}
    wait_for {displayed?(NOT_SAVED_CLOSE_BUTTON)}
    click_on(NOT_SAVED_CLOSE_BUTTON)
  end

  def click_button(button)
    verifiable = ['table','graph','map','slider','calc','text']

    case (button)
      when 'table'
        element = TABLE_BUTTON
      when 'graph'
        element = GRAPH_BUTTON
      when 'map'
        element = MAP_BUTTON
      when 'slider'
        element = SLIDER_BUTTON
      when 'calc'
        element = CALC_BUTTON
      when 'text'
        element = TEXT_BUTTON
      when 'tilelist'
        element = TILE_LIST_BUTTON
      when 'option'
        element = OPTION_BUTTON
      when 'guide'
        element = GUIDE_BUTTON
      when 'toolshelf'
        element = TOOLSHELF_BACK
      when 'background'
        element = BACKGROUND
      when 'separator'
        element = OPTION_MENU_SEPARATOR
      when 'examples'
        element = OPEN_EXAMPLE_DOCS
      when 'cloud'
        element = OPEN_CONCORD_CLOUD
      when 'google drive'
        element = OPEN_GOOGLE_DRIVE
      when 'local'
        element = OPEN_LOCAL_FILE
    end

    puts "button is #{button}, element is #{element}"
    click_on(element)
    if verifiable.include? button
      puts "#{button} Button is in verifiable"
      verify_tile(element)
    end
    if button == 'option'
      puts "In option if. #{OPEN_CODAP_WEBSITE}"
      click_on(OPEN_CODAP_WEBSITE)
      verify_tile(WEBVIEW_FRAME)
      sleep(5)
    end
    if button == "tilelist"
      puts "In tilelist if #{TILE_MENU_ITEM}"
      click_on(TILE_MENU_ITEM)
    end
  end

  def undo
    click_on(UNDO_BUTTON)
  end

  def redo
    click_on(REDO_BUTTON)
  end

  def open_local_doc(doc_name)
    puts "File name is: #{doc_name}"
    wait_for {displayed? (OPEN_LOCAL_FILE)}
    click_button('local')
    wait_for {displayed? (FILE_SELECTION_DROP_AREA)}
    find(FILE_SELECTION_DROP_AREA).send_keys doc_name

  end

  def click_toolshelf
    #@codap_base.click_on(TOOLSHELF_BACK)
    @@driver.find_element(TOOLSHELF_BACK).click
  end

  def drag_scroller
    scroll = find(H_SCROLLER)
    driver.action.drag_and_drop_by(scroll, 100, 0).perform
  end

  def drag_scroller_right
    puts "In drag_scroller_right"
    scroll_right = find(SCROLL_H_RIGHT)
    puts "Found element #{scroll_right}"
    driver.action.drag_and_drop_by(scroll_right, 50, 0).perform
    #scroll_right.click
  end

  # def verify_page
  #   expect(driver.title).to include('CODAP')
  # end

  def verify_tile(button)
    case (button)
      when TABLE_BUTTON
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
        click_on(TEXT_TILE)
      when HELP_BUTTON
        # help_page_title = driver.find_element(:id, "block-menu-menu-help-categories")
        # wait_for {displayed?(help_page_title)}
        # expect(help_page_title.text).to include "CODAP Help"
        puts "Help button clicked."
      when TILE_LIST_BUTTON
        puts "Tile list button clicked"
      #driver.find_element(:xpath=> '//span[contains(@class, "ellipsis") and text()="No Data"]').click
      when OPTION_BUTTON
        wait_for {displayed? (VIEW_WEBPAGE_MENU_ITEM)}
        click_on(VIEW_WEBPAGE_MENU_ITEM)
        textfield = wait_for{find(SINGLE_TEXT_DIALOG_TEXTFIELD)}
        driver.action.click(textfield).perform
        find(SINGLE_TEXT_DIALOG_CANCEL_BUTTON).click
      # puts "Option button clicked"
      when GUIDE_BUTTON
        puts "Guide button clicked"
    end
  end

  def verify_doc_title(doc_name)
    expect(driver.title).to include(doc_name)
  end

  def dismiss_splashscreen
    if !find(SPLASHSCREEN) #Dismisses the splashscreen if present
      sleep(5)
    else
      click_on(SPLASHSCREEN)
    end
  end

end


