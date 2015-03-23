# Methods for date class
class Date
  alias_method :succ, :next

  def beginning_of_month
    self.class.new year, month, 1
  end

  def end_of_month
    self.class.new year, month + 1, 0
  end

  class << self
    def this_week
      Date.week(Date.today)
    end

    def last_week
      Date.week(Date.today - 7)
    end

    # Returns the monday of the current week
    #
    # @return [Date] The date
    def monday(date = Date.today)
      today = date
      day = today.wday
      diff = case day
             when 0
               6
             when 1..6
               day - 1
             end
      today - diff
    end

    # Returns the week days in the current week
    #
    # @return [Array] The days as dates
    def week(date)
      day = monday(date)
      (day..day + 6)
    end
  end
end
