defmodule QappWeb.QuestionLive.Question do
  use QappWeb, :live_view

  alias Qapp.Devices
  alias Qapp.Devices.Question

  @impl true
  def mount(_params, _session, socket) do
    # this is the question with the lowest id in the database
    # not ideal but for this exercise it works
    question = Devices.get_first_question()

    {:ok,
      socket
      |> assign(:all_questions, Devices.list_device_questions())
      |> assign(:question, question)
      |> assign(:grade, "")}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"id" => id, "answer" => true}, socket) do
    question = Devices.get_question!(id)

    if question.yes_has_next_question && !is_nil(question.next_question_id) do
      {:noreply,
        socket
        |> assign(:question, Devices.get_question!(question.next_question_id))
        |> assign(:all_questions, update_answered_questions(socket, question, true))
        |> assign(:grade, "")}
    else
      {:noreply,
        socket
        |> assign(:grade, question.yes_grade)
        |> assign(:all_questions, update_answered_questions(socket, question, true))}
    end
  end

  def handle_event("answer", %{"id" => id, "answer" => false}, socket) do
    question = Devices.get_question!(id)

    if question.no_has_next_question && !is_nil(question.next_question_id) do
      {:noreply,
        socket
        |> assign(:question, Devices.get_question!(question.next_question_id))
        |> assign(:all_questions, update_answered_questions(socket, question, true))
        |> assign(:grade, "")}
    else
      {:noreply,
        socket
        |> assign(:grade, question.no_grade)
        |> assign(:all_questions, update_answered_questions(socket, question, true))}
    end
  end

  @impl true
  def handle_info({QappWeb.QuestionLive.FormComponent, {:saved, question}}, socket) do
    {:noreply, stream_insert(socket, :device_questions, question)}
  end

  defp update_answered_questions(socket, question, answer) when is_boolean(answer) do
    Enum.map(socket.assigns.all_questions, fn q ->
      if q.id == question.id,
        do: %{q | is_answered: answer},
        else: q
    end)
  end
  defp update_answered_questions(socket, _question, _answer), do: socket.assigns.all_questions
end
