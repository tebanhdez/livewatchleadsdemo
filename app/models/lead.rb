class Lead < ActiveRecord::Base
  attr_accessible :lead_date, :lead_source, :sales_rep, :status, :url
end
