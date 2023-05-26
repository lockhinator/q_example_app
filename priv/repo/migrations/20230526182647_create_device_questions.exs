defmodule Qapp.Repo.Migrations.CreateDeviceQuestions do
  use Ecto.Migration

  def change do
    create table(:device_questions) do
      add :name, :text
      add :yes_grade, :string
      add :no_grade, :string
      add :no_has_next_question, :boolean, default: false, null: false
      add :yes_has_next_question, :boolean, default: false, null: false
      add :next_question_id, :integer

      timestamps()
    end
  end
end
