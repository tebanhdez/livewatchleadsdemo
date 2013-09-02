require 'csv'
class DashboardController < ApplicationController
  
  def show_live_watch_leads
        load_csv if Lead.all.count == 0
        @status =  [ "DNC", "Bad or No Phone", "Nothing Scheduled", "Email Only", "Lead Line", "Task No Quote", "Task w/ Quote", "Sold", "Appt Scheduled", "Leads Created" ] #Lead.all.map(&:status).uniq
        
        @dates = Lead.all.collect{|lead|  lead.lead_date  }.uniq
        
        @leads = Lead.all
        @data = []
        @leads_per_date = []

        @status.each do |status|
        	json = {name: status, data: [], stack: 0 } 
        	@dates.each do |date|
        		if status.downcase == "sold" or status.downcase == "appt scheduled"
        			json[:data] << get_data_by_status_and_date(status, date)
        		else
        			json[:data] << -get_data_by_status_and_date(status, date)
        		end
        	end
        	@data << json.to_json
        end
        @dates = @dates.collect{|date|  date.to_s}

        index = 0
        @dates.each do
        	subTotal = 0
        	@data.each do |datum|
        		subTotal += JSON.parse(datum)["data"][index].abs
        	end
        	index += 1
        	@leads_per_date << subTotal
        end

  end

  def  get_data_by_status_and_date status, date
  		Lead.where("lower(status) = ? AND lead_date = ?", status.downcase, date).count
  end 

  def refresh_livewatch_leads

  end

  def load_csv 
    CSV.foreach(Dir.pwd + "/csv.csv") do |row|
    	date = row[0].split("/")
    	d = DateTime.new(date[2].to_i + 2000, date[0].to_i, date[1].to_i )
    	Lead.create({ lead_date: d, lead_source: row[1], sales_rep: row[2], status: row[3], url: row[4]})
    end
  end

end
