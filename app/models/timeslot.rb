class Timeslot < ActiveRecord::Base

  has_and_belongs_to_many :sections

  # makes a timeslot from the given input
  def self.make_timeslot(day, start_time)
    start_time = start_time.to_s
    if start_time.length < 4
      start_time = "0" + start_time
    end
    timeslot = find_timeslot(day, start_time)
    if not timeslot
      timeslot = Timeslot.new
      timeslot.day = day
      timeslot.start_time = Time.strptime(start_time, "%H%M")
      timeslot.save
    end
    return timeslot
  end

  def self.find_timeslot(day, start_time)
    self.where("day = ?", day).where("start_time = ?", Time.strptime(start_time, "%H%M")).first
  end

  def find_buildings
    buildings = {}
    self.sections.each do |section|
      buildings[section.building] = true
    end
    buildings.keys
  end

  def find_building_population(building)
    population = 0
    self.sections.each do |section|
      if section.building == building
        population += section.get_population
      end
    end
    population
  end
end
