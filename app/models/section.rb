class Section < ActiveRecord::Base

  include AdditionalMethods

  belongs_to :class
  has_and_belongs_to_many :timeslots

  def self.make_section(building, population, days, start_time, end_time)
    section = Section.new
    section.building = building
    section.population = population
    section.save
    section.update_timeslots(days, start_time, end_time)
  end

  def update_timeslots(days, start_time, end_time)
    times = split_times(start_time, end_time)
    days.split("").each do
      # if is day
      times.each do
        self.timeslots << Timeslot.make_timeslot(#day, start)
      end
    end
    self.last_updated = DateTime.now
    self.save
  end
    
    
end
