defmodule QappWeb.QuestionLiveTest do
  use QappWeb.ConnCase

  import Phoenix.LiveViewTest
  import Qapp.DevicesFixtures

  @create_attrs %{name: "some name", next_question_id: 42, no_grade: "some no_grade", no_has_next_question: true, yes_grade: "some yes_grade", yes_has_next_question: true}
  @update_attrs %{name: "some updated name", next_question_id: 43, no_grade: "some updated no_grade", no_has_next_question: false, yes_grade: "some updated yes_grade", yes_has_next_question: false}
  @invalid_attrs %{name: nil, next_question_id: nil, no_grade: nil, no_has_next_question: false, yes_grade: nil, yes_has_next_question: false}

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end

  describe "Index" do
    setup [:create_question]

    test "lists all device_questions", %{conn: conn, question: question} do
      {:ok, _index_live, html} = live(conn, ~p"/questions")

      assert html =~ "Listing Device questions"
      assert html =~ question.name
    end

    test "saves new question", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/questions")

      assert index_live |> element("a", "New Question") |> render_click() =~
               "New Question"

      assert_patch(index_live, ~p"/questions/new")

      assert index_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#question-form", question: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/questions")

      html = render(index_live)
      assert html =~ "Question created successfully"
      assert html =~ "some name"
    end

    test "updates question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/questions")

      assert index_live |> element("#device_questions-#{question.id} a", "Edit") |> render_click() =~
               "Edit Question"

      assert_patch(index_live, ~p"/questions/#{question}/edit")

      assert index_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#question-form", question: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/questions")

      html = render(index_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/questions")

      assert index_live |> element("#device_questions-#{question.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#device_questions-#{question.id}")
    end
  end

  describe "Show" do
    setup [:create_question]

    test "displays question", %{conn: conn, question: question} do
      {:ok, _show_live, html} = live(conn, ~p"/questions/#{question}")

      assert html =~ "Show Question"
      assert html =~ question.name
    end

    test "updates question within modal", %{conn: conn, question: question} do
      {:ok, show_live, _html} = live(conn, ~p"/questions/#{question}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Question"

      assert_patch(show_live, ~p"/questions/#{question}/show/edit")

      assert show_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#question-form", question: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/questions/#{question}")

      html = render(show_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated name"
    end
  end
end
