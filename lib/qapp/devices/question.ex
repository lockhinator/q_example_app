defmodule Qapp.Devices.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "device_questions" do
    field :name, :string
    field :next_question_id, :integer, default: nil
    field :no_grade, :string
    field :no_has_next_question, :boolean, default: false
    field :yes_grade, :string
    field :yes_has_next_question, :boolean, default: false
    field :is_answered, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:name, :yes_grade, :no_grade, :no_has_next_question, :yes_has_next_question, :next_question_id])
    |> validate_required([:name])
  end
end
