module CFMObject
  #User Entry Buttons Locators
  USER_ENTRY_NEW_DOC_BUTTON = {xpath: '//button[contains(.,"Create New Document")]'}
  USER_ENTRY_OPEN_DOC_BUTTON = {xpath: '//button[contains(.,"Open Document")]'}
  USER_ENTRY_AUTHORIZE_DOC_BUTTON = {xpath: '//button[contains(.,"Authorize")]'}

  #Open Dialog box locators
  OPEN_EXAMPLE_DOCS = {css: '.workspace-tabs >ul:nth-of-type(1)> li'}#.workspace-tabs>ul>li:contains("Example Documents")
  OPEN_CONCORD_CLOUD = {css: '.workspace-tabs >ul:nth-of-type(2) > li'}
  OPEN_GOOGLE_DRIVE = {css: '.workspace-tabs >ul:nth-of-type(3) > li'}
  OPEN_LOCAL_FILE = {css: '.workspace-tabs >ul:nth-of-type(4) > li'}
  FILE_SELECTION_DROP_AREA = {css: '.dropArea>input'}
  DOC_STORE_LOGIN = {css: '.document-store-footer'}
  SAVE_CONCORD_CLOUD = {css: '.workspace-tabs > ul:nth-child(1) > li'}
  SAVE_GOOGLE_DRIVE = {css: '.workspace-tabs > ul:nth-child(2) > li'}
  FILE_MENU = { css: '.menu-anchor'}
  FILE_NEW = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(1)'}
  FILE_OPEN = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(2)'}
  FILE_CLOSE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(3)'}
  FILE_IMPORT = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(4)'}
  FILE_REVERT = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(5)'}
  FILE_SAVE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(7)'}
  FILE_COPY = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(8)'}
  FILE_SHARE = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(9)'}
  FILE_DOWNLOAD = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(10)'}
  FILE_RENAME = {css: '.menu-showing> ul:nth-child(1)> li:nth-child(11)'}

  def in_cfm
    puts "In CFMObject"
  end
end