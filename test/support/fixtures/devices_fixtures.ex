defmodule Qapp.DevicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qapp.Devices` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        name: "some name",
        next_question_id: 42,
        no_grade: "some no_grade",
        no_has_next_question: true,
        yes_grade: "some yes_grade",
        yes_has_next_question: true
      })
      |> Qapp.Devices.create_question()

    question
  end
end
