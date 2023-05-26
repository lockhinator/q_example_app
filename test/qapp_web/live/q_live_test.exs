defmodule QappWeb.QLiveTest do
  use QappWeb.ConnCase

  import Phoenix.LiveViewTest
  import Qapp.DevicesFixtures

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end

  describe "Renders Initial Page" do
    setup [:create_question]

    test "lists question", %{conn: conn, question: question} do
      {:ok, _index_live, html} = live(conn, ~p"/q")

      assert html =~ question.name
      assert html =~ "Yes"
      assert html =~ "No"
      assert html =~ "Devices Current Grade:"
    end
  end

  describe "Handles Option Clicks As Expected" do
    test "when clicks option grade is displayed", %{conn: conn} do
      question = question_fixture(%{
        yes_grade: "A",
        no_grade: "Z",
        yes_has_next_question: false,
        no_has_next_question: false
      })

      {:ok, index_live, html} = live(conn, ~p"/q")

      assert html =~ question.name
      assert html =~ "Yes"
      assert html =~ "No"
      assert html =~ "Devices Current Grade:"

      # check we do not have an intial grade
      refute html =~ "Devices Current Grade: A"
      refute html =~ "Devices Current Grade: Z"

      assert index_live |> element("button", "Yes") |> render_click() =~
               "Devices Current Grade: A"

      assert index_live |> element("button", "No") |> render_click() =~
               "Devices Current Grade: Z"
    end
  end
end
