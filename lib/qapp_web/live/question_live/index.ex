defmodule QappWeb.QuestionLive.Index do
  use QappWeb, :live_view

  alias Qapp.Devices
  alias Qapp.Devices.Question

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :device_questions, Devices.list_device_questions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, Devices.get_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Device questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_info({QappWeb.QuestionLive.FormComponent, {:saved, question}}, socket) do
    {:noreply, stream_insert(socket, :device_questions, question)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Devices.get_question!(id)
    {:ok, _} = Devices.delete_question(question)

    {:noreply, stream_delete(socket, :device_questions, question)}
  end
end
