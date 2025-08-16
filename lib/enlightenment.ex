defmodule Enlightenment do
  @moduledoc """
  The core framework for the Elixir Koans.

  This module provides the testing infrastructure and zen-like feedback
  system for learning Elixir through contemplation and practice.
  """

  defmodule Sensei do
    @moduledoc """
    The Sensei observes your progress and provides guidance.
    """

    defstruct [:pass_count, :total_count, :failed_test, :observations, :progress]

    def new do
      %__MODULE__{
        pass_count: 0,
        total_count: 0,
        failed_test: nil,
        observations: [],
        progress: []
      }
    end

    def observe(sensei, step) do
      cond do
        step.passed? ->
          new_pass_count = sensei.pass_count + 1

          observation =
            if new_pass_count > List.last(sensei.progress, 0) do
              IO.ANSI.green() <>
                "#{step.koan_file}##{step.name} has expanded your awareness." <> IO.ANSI.reset()
            else
              nil
            end

          observations =
            if observation, do: [observation | sensei.observations], else: sensei.observations

          %{sensei | pass_count: new_pass_count, observations: observations}

        true ->
          observations = [
            IO.ANSI.red() <>
              "#{step.koan_file}##{step.name} has damaged your karma." <> IO.ANSI.reset()
            | sensei.observations
          ]

          %{
            sensei
            | failed_test: step,
              observations: observations,
              progress: [sensei.pass_count | sensei.progress]
          }
      end
    end

    def failed?(sensei) do
      sensei.failed_test != nil
    end

    def instruct(sensei) do
      if failed?(sensei) do
        Enum.reverse(sensei.observations)
        |> Enum.each(&IO.puts/1)

        encourage(sensei)
        guide_through_error(sensei)
        zen_statement(sensei)
        show_progress(sensei)
      else
        end_screen()
      end
    end

    defp encourage(sensei) do
      IO.puts("")
      IO.puts("The Master says:")
      IO.puts(IO.ANSI.cyan() <> "  You have not yet reached enlightenment." <> IO.ANSI.reset())

      recent_progress = Enum.take(sensei.progress, 5)

      cond do
        length(recent_progress) == 5 and Enum.uniq(recent_progress) |> length() == 1 ->
          IO.puts(
            IO.ANSI.cyan() <>
              "  I sense frustration. Do not be afraid to ask for help." <> IO.ANSI.reset()
          )

        length(Enum.take(sensei.progress, 2)) == 2 and
            Enum.take(sensei.progress, 2) |> Enum.uniq() |> length() == 1 ->
          IO.puts(IO.ANSI.cyan() <> "  Do not lose hope." <> IO.ANSI.reset())

        sensei.pass_count > 0 ->
          IO.puts(
            IO.ANSI.cyan() <>
              "  You are progressing. Excellent. #{sensei.pass_count} completed." <>
              IO.ANSI.reset()
          )

        true ->
          :ok
      end
    end

    defp guide_through_error(sensei) do
      if sensei.failed_test do
        IO.puts("")
        IO.puts("The answers you seek...")
        IO.puts(IO.ANSI.red() <> sensei.failed_test.failure <> IO.ANSI.reset())
        IO.puts("")
        IO.puts("Please meditate on the following code:")
        IO.puts("#{sensei.failed_test.file}:#{sensei.failed_test.line}")
        IO.puts("")
      end
    end

    defp zen_statement(sensei) do
      statement =
        case rem(sensei.pass_count, 10) do
          0 -> "mountains are merely mountains"
          1 -> "learn the rules so you know how to break them properly"
          2 -> "learn the rules so you know how to break them properly"
          3 -> "remember that silence is sometimes the best answer"
          4 -> "remember that silence is sometimes the best answer"
          5 -> "sleep is the best meditation"
          6 -> "sleep is the best meditation"
          7 -> "when you lose, don't lose the lesson"
          8 -> "when you lose, don't lose the lesson"
          9 -> "things are not what they appear to be: nor are they otherwise"
        end

      IO.puts(IO.ANSI.green() <> statement <> IO.ANSI.reset())
    end

    defp show_progress(sensei) do
      bar_width = 50
      total_tests = sensei.total_count

      if total_tests > 0 do
        scale = bar_width / total_tests
        print_green("your path thus far [")

        happy_steps = trunc(sensei.pass_count * scale)
        happy_steps = if happy_steps == 0 and sensei.pass_count > 0, do: 1, else: happy_steps

        print_green(String.duplicate(".", happy_steps))

        if failed?(sensei) do
          print_red("X")
          remaining = bar_width - 1 - happy_steps
          print_cyan(String.duplicate("_", remaining))
        end

        print_green("]")
        percentage = if total_tests > 0, do: trunc(sensei.pass_count * 100 / total_tests), else: 0
        IO.puts(" #{sensei.pass_count}/#{total_tests} (#{percentage}%)")
      end
    end

    defp print_green(text), do: IO.write(IO.ANSI.green() <> text <> IO.ANSI.reset())
    defp print_red(text), do: IO.write(IO.ANSI.red() <> text <> IO.ANSI.reset())
    defp print_cyan(text), do: IO.write(IO.ANSI.cyan() <> text <> IO.ANSI.reset())

    defp end_screen do
      IO.puts(IO.ANSI.green() <> "Mountains are again merely mountains" <> IO.ANSI.reset())
      IO.puts("")

      IO.puts("""
                                        ,,   ,  ,,
                                      :      ::::,    :::,
                         ,        ,,: :::::::::::::,,  ::::   :  ,
                       ,       ,,,   ,:::::::::::::::::::,  ,:  ,: ,,
                  :,        ::,  , , :, ,::::::::::::::::::, :::  ,::::
                 :   :    ::,                          ,:::::::: ::, ,::::
                ,     ,:::::                                  :,:::::::,::::,
            ,:     , ,:,,:                                       :::::::::::::
           ::,:   ,,:::,                                           ,::::::::::::,
          ,:::, :,,:::                                               ::::::::::::,
         ,::: :::::::,         Mountains are again merely mountains    ,::::::::::::
         :::,,,::::::                                                   ::::::::::::
       ,:::::::::::,                                                    ::::::::::::,
       :::::::::::,                                                     ,::::::::::::
      :::::::::::::                                                     ,::::::::::::
      ::::::::::::                      Elixir Koans                     ::::::::::::
      ::::::::::::#{String.pad_leading("(in Elixir)", 54)},::::::::::::
      :::::::::::,                                                      , :::::::::::
      ,:::::::::::::,                brought to you by                 ,,::::::::::::
      ::::::::::::::                                                    ,::::::::::::
       ::::::::::::::,               the Elixir Community              ,:::::::::::::
       ::::::::::::,                                                   , ::::::::::::
        :,::::::::: ::::                                               :::::::::::::
         ,:::::::::::  ,:                                          ,,:::::::::::::,
           ::::::::::::                                           ,::::::::::::::,
            :::::::::::::::::,                                  ::::::::::::::::
             :::::::::::::::::::,                             ::::::::::::::::
              ::::::::::::::::::::::,                     ,::::,:, , ::::,:::
               ,::::::::::::::::::::::                    :::,,:::::::::,:::
                ,::::::::::::::::::::                      :::::::::::::,::
                 ,:::::::::::::::::                         ,:::::::::::,
                  :::::::::::::::                            ::::::::,
                   ,::::::::::::                              :::::
                    ,::::::::::                               :
                     ::::::::
                      ,:::::
                       ,:::
                        :
      """)
    end
  end

  defmodule Step do
    @moduledoc """
    Represents a single test step in the path to enlightenment.
    """

    defstruct [:name, :koan_file, :step_count, :passed?, :failure, :file, :line]

    def new(name, koan_file, step_count) do
      %__MODULE__{
        name: name,
        koan_file: koan_file,
        step_count: step_count,
        passed?: false,
        failure: nil,
        file: nil,
        line: nil
      }
    end

    def passed(step) do
      %{step | passed?: true}
    end

    def failed(step, failure, file \\ nil, line \\ nil) do
      %{step | passed?: false, failure: failure, file: file, line: line}
    end
  end

  defmodule ThePath do
    @moduledoc """
    The path to enlightenment - orchestrates the journey through all koans.
    """

    def walk(modules) do
      sensei = Sensei.new()

      # Count total tests first
      total_tests =
        modules
        |> Enum.reduce(0, fn module, acc ->
          acc + count_tests(module)
        end)

      sensei = %{sensei | total_count: total_tests}

      # Walk through each koan
      {final_sensei, _} =
        modules
        |> Enum.with_index(1)
        |> Enum.reduce_while({sensei, 1}, fn {module, koan_index}, {current_sensei, step_count} ->
          case walk_koan(module, current_sensei, koan_index, step_count) do
            {:halt, new_sensei, new_step_count} -> {:halt, {new_sensei, new_step_count}}
            {:cont, new_sensei, new_step_count} -> {:cont, {new_sensei, new_step_count}}
          end
        end)

      Sensei.instruct(final_sensei)
    end

    defp walk_koan(module, sensei, _koan_index, step_count) do
      test_functions = get_test_functions(module)

      {final_sensei, final_step_count, should_halt} =
        Enum.reduce_while(test_functions, {sensei, step_count, false}, fn test_func,
                                                                          {current_sensei,
                                                                           current_step_count,
                                                                           _halt} ->
          step = Step.new(test_func, module, current_step_count)

          step_result =
            try do
              apply(module, test_func, [])
              Step.passed(step)
            catch
              :exit, {:__assertion_failed__, failure} ->
                # Extract file and line from stacktrace
                stacktrace = __STACKTRACE__

                case stacktrace do
                  [{_module, ^test_func, _, info} | _] ->
                    file = info[:file] || "unknown"
                    line = info[:line] || 0
                    Step.failed(step, failure, file, line)

                  _ ->
                    Step.failed(step, failure, "unknown", 0)
                end

              kind, error ->
                Step.failed(step, "#{kind}: #{inspect(error)}")
            end

          new_sensei = Sensei.observe(current_sensei, step_result)

          if step_result.passed? do
            {:cont, {new_sensei, current_step_count + 1, false}}
          else
            {:halt, {new_sensei, current_step_count + 1, true}}
          end
        end)

      if should_halt do
        {:halt, final_sensei, final_step_count}
      else
        {:cont, final_sensei, final_step_count}
      end
    end

    defp count_tests(module) do
      length(get_test_functions(module))
    end

    defp get_test_functions(module) do
      module.__info__(:functions)
      |> Enum.filter(fn {name, arity} ->
        arity == 0 and String.starts_with?(to_string(name), "test_")
      end)
      |> Enum.map(fn {name, _arity} -> name end)
      |> Enum.sort()
    end
  end

  @doc """
  The main assertion function. Fails if the given expression is falsy.
  """
  defmacro assert(expr) do
    quote do
      case unquote(expr) do
        val when val in [false, nil] ->
          exit({:__assertion_failed__, "Expected #{inspect(unquote(expr))} to be truthy"})

        _ ->
          true
      end
    end
  end

  @doc """
  Assertion for equality. Fails if expected != actual.
  """
  defmacro assert_equal(expected, actual) do
    quote do
      expected_val = unquote(expected)
      actual_val = unquote(actual)

      if expected_val != actual_val do
        exit(
          {:__assertion_failed__,
           "Expected #{inspect(expected_val)}, but got #{inspect(actual_val)}"}
        )
      end

      true
    end
  end

  @doc """
  Assertion that an exception is raised. Fails if no exception or wrong exception.
  """
  defmacro assert_raise(expected_exception, fun) do
    quote do
      try do
        unquote(fun).()

        exit(
          {:__assertion_failed__,
           "Expected #{inspect(unquote(expected_exception))} to be raised, but nothing was raised"}
        )
      rescue
        error ->
          if error.__struct__ == unquote(expected_exception) do
            true
          else
            exit(
              {:__assertion_failed__,
               "Expected #{inspect(unquote(expected_exception))} to be raised, but got #{inspect(error.__struct__)}"}
            )
          end
      end
    end
  end

  @doc """
  Assertion that nothing is raised. Fails if any exception is raised.
  """
  defmacro assert_nothing_raised(fun) do
    quote do
      try do
        unquote(fun).()
        true
      rescue
        error ->
          exit(
            {:__assertion_failed__,
             "Expected nothing to be raised, but got #{inspect(error.__struct__)}: #{Exception.message(error)}"}
          )
      end
    end
  end

  @doc """
  Placeholder for student answers. Always fails with helpful message.
  """
  def __ do
    exit({:__assertion_failed__, "Please replace __ with the correct answer"})
  end

  @doc """
  Placeholder for numeric student answers. Always fails with helpful message.
  """
  def _n_ do
    exit({:__assertion_failed__, "Please replace _n_ with the correct number"})
  end

  @doc """
  Placeholder for string student answers. Always fails with helpful message.
  """
  def _s_ do
    exit({:__assertion_failed__, "Please replace _s_ with the correct string"})
  end
end
