module WorkbasketHelpers
  module Association
    extend ActiveSupport::Concern

    included do
      many_to_one :workbasket, key: :workbasket_id,
                               foreign_key: :id,
                               class_name: "Workbaskets::Workbasket"

      dataset_module do
        def by_workbasket(workbasket_id)
          where(workbasket_id: workbasket_id)
        end
      end
    end

    def move_status_to!(new_status)
      self.status = new_status
      save
    end
  end
end
