# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'
require 'csv'

describe Export::Tabular::People::PeopleAddress do

  let(:person) { people(:top_leader) }
  let(:list) { [person] }
  let(:simple_headers) do
    ['Vorname', 'Nachname', 'Übername', 'Firmenname', 'Firma', 'Haupt-E-Mail',
     'Adresse', 'PLZ', 'Ort', 'Land', 'Geschlecht', 'Geburtstag', 'Rollen']
  end
  let(:data) { Export::Tabular::People::PeopleAddress.csv(list) }
  let(:csv) { CSV.parse(data, headers: true, col_sep: Settings.csv.separator) }

  subject { csv }

  its(:headers) { should == simple_headers }

  context 'first row' do

    subject { csv[0] }

    its(['Vorname']) { should eq person.first_name }
    its(['Nachname']) { should eq person.last_name }
    its(['Haupt-E-Mail']) { should eq person.email }
    its(['Ort']) { should eq person.town }
    its(['Geschlecht']) { should eq 'unbekannt' }

    context 'roles and phone number' do
      before do
        Fabricate(Group::BottomGroup::Member.name.to_s, group: groups(:bottom_group_one_one), person: person)
        person.phone_numbers.create!(label: 'vater', number: 123)
        person.additional_emails.create!(label: 'Vater', email: 'vater@example.com')
        person.additional_emails.create!(label: 'Mutter', email: 'mutter@example.com', public: false)
      end

      its(['Telefonnummer Vater']) { should eq '123' }
      its(['Weitere E-Mail Vater']) { should eq 'vater@example.com' }
      its(['Weitere E-Mail Mutter']) { should be_nil }

      it 'roles should be complete' do
        expect(subject['Rollen'].split(', ')).to match_array(['Member Bottom One / Group 11', 'Leader Top / TopGroup'])
      end
    end
  end

end
