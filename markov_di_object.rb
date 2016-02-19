class MarkovDIObject
  MARKOV_DOC_TITLE = {xpath: '//div[contains(@class, "titleview") and text()="Markov"]'}
  PLAY_BUTTON = {id: 'start_game_button'}
  STRATEGY_BUTTON = {id: 'strategy_button'}
  ROCK_BUTTON = {id: 'rock_button'}
  PAPER_BUTTON = {id: 'paper_button'}
  SCISSORS_BUTTON = {id: 'scissors_button'}
  GAME_BUTTON = {id: 'game_button'}
  LEVELS_BUTTON = {id: 'levels_button'}

  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def click_play_button
    driver.find_element(PLAY_BUTTON).click
  end

  def click_rock_button
    driver.find_element(ROCK_BUTTON).click
  end

  def click_paper_button
    driver.find_element(PAPER_BUTTON).click
  end

  def click_scissors_button
    driver.find_element(SCISSORS_BUTTON).click
  end

  def click_game_button
    driver.find_element(GAME_BUTTON).click
  end

  def click_levels_button
    driver.find_element(LEVELS_BUTTON).click
  end
end