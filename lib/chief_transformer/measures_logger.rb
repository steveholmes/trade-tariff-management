require 'fileutils'

# each line in *.json.txt files is a json object of measure candidate
class ChiefTransformer
  class MeasuresLogger
    class << self
      def created(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(candidate.origin, :created), "a+") do |f|
          f.puts(candidate.values.to_json)
        end
      end

      def failed(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(candidate.origin, :failed), "a+") do |f|
          f.puts(
            candidate.values.merge(
              errors: candidate.errors,
              mfcm: candidate.mfcm.try(:values),
              tame: candidate.tame.try(:values),
              tamf: candidate.tamf.try(:values)
            ).to_json
          )
        end
      end

      def upload_to_s3(origin)
        return unless TariffSynchronizer.measures_logger_enabled

        [:created, :failed].each do |type|
          TariffSynchronizer::FileService.upload_file(
            tmp_file_path(origin, type), file_path(origin, type)
          )
        end
      end

      def delete_tmp_file(origin)
        return if origin.nil?

        [:created, :failed].each do |type|
          FileUtils.rm_f(tmp_file_path(origin, type))
        end
      end

      # local tmp file path
      def tmp_file_path(origin, type)
        File.join(Rails.root, file_path(origin, type))
      end

      # file path on S3
      def file_path(origin, type)
        origin = File.basename(origin.to_s, ".*")
        File.join(TariffSynchronizer.root_path, "measures", "#{origin}-#{type}.json.txt")
      end
    end
  end
end
