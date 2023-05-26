defmodule Qapp.DevicesTest do
  use Qapp.DataCase

  alias Qapp.Devices

  describe "device_questions" do
    alias Qapp.Devices.Question

    import Qapp.DevicesFixtures

    @invalid_attrs %{name: nil, next_question_id: nil, no_grade: nil, no_has_next_question: nil, yes_grade: nil, yes_has_next_question: nil}

    test "list_device_questions/0 returns all device_questions" do
      question = question_fixture()
      assert Devices.list_device_questions() == [question]
    end

    test "get_first_question/0 returns the first question" do
      question1 = question_fixture()
      question2 = question_fixture()
      assert Devices.get_first_question() == question1
      refute Devices.get_first_question() == question2
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Devices.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{name: "some name", next_question_id: 42, no_grade: "some no_grade", no_has_next_question: true, yes_grade: "some yes_grade", yes_has_next_question: true}

      assert {:ok, %Question{} = question} = Devices.create_question(valid_attrs)
      assert question.name == "some name"
      assert question.next_question_id == 42
      assert question.no_grade == "some no_grade"
      assert question.no_has_next_question == true
      assert question.yes_grade == "some yes_grade"
      assert question.yes_has_next_question == true
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{name: "some updated name", next_question_id: 43, no_grade: "some updated no_grade", no_has_next_question: false, yes_grade: "some updated yes_grade", yes_has_next_question: false}

      assert {:ok, %Question{} = question} = Devices.update_question(question, update_attrs)
      assert question.name == "some updated name"
      assert question.next_question_id == 43
      assert question.no_grade == "some updated no_grade"
      assert question.no_has_next_question == false
      assert question.yes_grade == "some updated yes_grade"
      assert question.yes_has_next_question == false
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_question(question, @invalid_attrs)
      assert question == Devices.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Devices.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Devices.change_question(question)
    end
  end
end
