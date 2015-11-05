#! /usr/bin/ruby
require 'optparse'
require 'date'
require 'csv'
#require 'testPerformanceHarness.rb'

result_file = "testRunResult.csv"
trial_num = 5
case_num = 10
test_num = 3
codap_root ='http://codap.concord.org/releases/'
codap_version = '/latest'
$browsers = ["chrome", "firefox"]
tLen = $browsers.length
i = 0
b = 0
$save_filename = "testruntests.csv"
$new_file = false

#Writes results from the performance harness to a csv file in the specified directory
def write_to_csv (test_run, time, browser_name, num_trial, num_cases, duration)
#  googledrive_path="Google Drive/CODAP @ Concord/Software Development/QA"
#  localdrive_path="Documents/CODAP data/"

  if !File.exist?("#{Dir.home}/#{$dir_path}/#{$save_filename}") || $new_file
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "wb") do |csv|
      csv<<["Test No.", "Time", "Browser", "Num of Trials", "Num of Cases", "Duration"]
      csv << [test_run, time, browser_name, num_trial, num_cases, duration]
    end
  else
    CSV.open("#{Dir.home}/#{$dir_path}/#{$save_filename}", "a") do |csv|
      csv << [test_run, time, browser_name, num_trial, num_cases, duration]
    end
  end
end

while i <= test_num do
  while b <= tLen do
    time_start = Time.now

    cmd = 'ruby testPerformanceHarness.rb -t #{trial_num} -c #{case_num} -b #{$browsers[b]} -r #{codap_root} -v #{codap_version}'
    time_end = Time.now
    test_duration = time_end - time_start
    write_to_csv(i,time_start,$browsers[b],trial_num, case_num, test_duration)
    b=b+1
  end
  i=i+1
end