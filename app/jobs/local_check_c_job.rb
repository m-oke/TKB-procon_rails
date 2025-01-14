class LocalCheckCJob < ActiveJob::Base
  queue_as :plagiarism

  def perform(user_id:, lesson_id:, question_id:, lesson_question_id:)

    answer = Answer.where(:student_id => user_id,
                          :lesson_id => lesson_id,
                          :question_id => question_id,
                          :lesson_question_id => lesson_question_id).last
    @target_dir = UPLOADS_ANSWERS_PATH.join(user_id.to_s, lesson_question_id.to_s).to_s
    @target_file = UPLOADS_ANSWERS_PATH.join(user_id.to_s, lesson_question_id.to_s, answer.file_name)
    @target_name = answer.file_name
    @target_path = @target_file.to_s
    check_count = 0
    local_result = []

    # check実行中はlocal_plagiarism_percentageを実行中に表示する
    answer.local_plagiarism_percentage = -1.0
    answer.save

    lesson_questions = LessonQuestion.where(:question_id => question_id)
    lesson_questions.each do |lesson_question|
      @lesson = Lesson.find_by(:id => lesson_question.lesson_id)

      students = User.where(:id => @lesson.user_lessons.where(:is_teacher => false).pluck(:user_id))
      students.each do |s|
        unless s.id == user_id
          compare_answer = Answer.accept_answer(:student_id => s.id,
                                                :question_id => question_id,
                                                :lesson_id => lesson_question.lesson_id,
                                                :lesson_question_id => lesson_question.id)
          if compare_answer.present? && (compare_answer.language == "c" || compare_answer.language == "cpp")

            @compare_file = UPLOADS_ANSWERS_PATH.join(s.id.to_s, lesson_question.id.to_s, compare_answer.file_name)
            @compare_name = compare_answer.file_name
            @compare_path = @compare_file.to_s
            @target_line = ""
            @compare_line = ""
            @check_token = 0

            @c_check = local_check_c(@target_file, @compare_file , user_id.to_s, s.id.to_s, @target_dir)

            @c_check.each_with_index do |line,i|
              if i == 0
                # Take the target file s token in first line
                target_token_left = line.rindex(@target_name + ":") + @target_name.size + 1
                target_token_right = line.rindex("tokens") - 1
                @target_token = line.strip[target_token_left..target_token_right]
              end
              if line.include?("|" + @compare_path )
                # Take the line No. in target file which is checked
                target_line_left = @target_path.size + 7
                target_line_right = line.rindex("|" + @compare_path ) - 1
                @target_line << line.strip[target_line_left..target_line_right] + ";"

                # Take the line No. in compare file which is checked
                compare_line_left = line.rindex(@compare_path) + @compare_path.size + 7
                compare_line_right = line.rindex("[") - 1
                @compare_line << line.strip[compare_line_left..compare_line_right] + ";"

                # Take the token be checked with target file and compare file
                check_token_left = line.rindex("[") + 1
                check_token_right = line.rindex("]") - 1
                @check_token += line[check_token_left..check_token_right].to_i

                check_count += 1
              end
            end
            # チェック実行で生成したファイルを削除
            File.delete(@target_dir + "/" + user_id.to_s + "_" + s.id.to_s + ".txt")

            # [目標ファイルtoken数,比較ファイル名,目標類似行,類似token数]の配列を作る
            if check_count == 0
              answer.local_plagiarism_percentage = 0.0
              answer.save
            else
              local_result.push([@target_token,@target_name,@compare_name,@target_line,@compare_line,@check_token,@compare_path,s.id,compare_answer.lesson_question_id])
            end
          end
        end
      end
    end
    if local_result.empty?
      answer.local_plagiarism_percentage = 0.0
      answer.save
      return
    end
    # SORT
    local_result = local_result.sort! do |item1,item2|
      item2[5]<=> item1[5]
    end
    result_temp = LocalCheckResult.new(:answer_id => answer.id,
                                       :check_result => (local_result[0][5].to_f/local_result[0][0].to_f*100) ,
                                       :target_name => local_result[0][1],
                                       :compare_name => local_result[0][2],
                                       :target_line => local_result[0][3],
                                       :compare_line => local_result[0][4],
                                       :compare_path => local_result[0][6],
                                       :compare_user_id => local_result[0][7],
                                       :compare_lesson_question_id => local_result[0][8])
    result_temp.save

    # アンサーの類似度を保存
    plagiarism_percentage = local_result[0][5].to_f/local_result[0][0].to_f*100
    answer.local_plagiarism_percentage = plagiarism_percentage.round(2)
    answer.save

    # File.delete(UPLOADS_ANSWERS_PATH.to_s + "/test.txt")

  end

  # チェックの実行とファイルの表示
  def local_check_c(target_file, compare_file, target_id, compare_id, target_dir)
    `sim_c #{target_file} / #{compare_file} > #{target_dir}/#{target_id}_#{compare_id}.txt`
    check = File.open(target_dir + '/' + target_id + '_' + compare_id + '.txt', 'r:utf-8')
    return check
  end
end
