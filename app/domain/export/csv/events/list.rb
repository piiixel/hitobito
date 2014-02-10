# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Export::Csv::Events
  class List < Export::Csv::Base

    MAX_DATES = 3

    self.model_class = Event::Course
    self.row_class = Export::Csv::Events::Row

    private

    def build_attribute_labels
      course_labels
          .merge(date_labels)
          .merge(prefixed_contactable_labels(:contact))
          .merge(prefixed_contactable_labels(:leader))
    end

    def course_labels
      { group_names: 'Organisatoren',
        number: human_attribute(:number),
        kind: Event::Kind.model_name.human,
        description: human_attribute(:description),
        state: human_attribute(:state),
        location: human_attribute(:location) }
    end

    def date_labels
      MAX_DATES.times.each_with_object({}) do |i, hash|
        hash[:"date_#{i}_label"] = "Datum #{i + 1} #{Event::Date.human_attribute_name(:label)}"
        hash[:"date_#{i}_location"] = "Datum #{i + 1} #{Event::Date.human_attribute_name(:location)}"
        hash[:"date_#{i}_duration"] = "Datum #{i + 1} Zeitraum"
      end
    end

    def prefixed_contactable_labels(prefix)
      contactable_keys.each_with_object({}) do |key, hash|
        hash[:"#{prefix}_#{key}"] = "#{translated_prefix(prefix)} #{Person.human_attribute_name(key)}"
      end
    end

    def contactable_keys
      [:name, :address, :zip_code, :town, :email, :phone_numbers]
    end

    def translated_prefix(prefix)
      case prefix
      when :leader then Event::Role::Leader.model_name.human
      when :contact then human_attribute(:contact)
      else prefix
      end
    end
  end
end