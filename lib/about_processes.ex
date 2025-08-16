defmodule AboutProcesses do
  @moduledoc """
  The Actor Model - processes are the fundamental unit of concurrency in Elixir.
  Processes are lightweight and isolated, communicating via message passing.

  ## Understanding the Actor Model in Elixir

  Elixir's concurrency model is based on the Actor Model, where "actors"
  (processes) are independent entities that:
  - Have their own state and memory
  - Communicate only through message passing
  - Handle one message at a time
  - Can create new actors
  - Can change their behavior

  ## Elixir Processes vs OS Threads

  **Elixir Processes:**
  - Lightweight (~2KB memory footprint)
  - Managed by the Erlang VM (BEAM)
  - Millions can run concurrently
  - Isolated memory (no shared state)
  - Fast creation/destruction
  - Built-in fault tolerance

  **OS Threads:**
  - Heavy (~8MB stack)
  - Managed by operating system
  - Hundreds to thousands concurrent
  - Shared memory space
  - Expensive creation/destruction
  - Complex synchronization needed

  ## Process Lifecycle

  1. **Spawn:** Create new process with spawn/1 or spawn_link/1
  2. **Execute:** Process runs its function
  3. **Communicate:** Send/receive messages
  4. **Exit:** Process terminates normally or abnormally
  5. **Cleanup:** Memory is garbage collected

  ## Message Passing Fundamentals

  Messages in Elixir are:
  - **Asynchronous:** send/2 doesn't block
  - **Ordered:** Messages between two specific processes maintain order
  - **Copied:** Data is copied between process boundaries
  - **Any data:** Any Elixir term can be sent as a message

  ## Concurrency Benefits

  **Fault Tolerance:** Process failures are isolated
  **Scalability:** Processes scale across CPU cores
  **Responsiveness:** Non-blocking message passing
  **Debugging:** Process state is encapsulated and inspectable
  **Distribution:** Processes can run on different machines

  ## Common Process Patterns

  **Server Processes:** Maintain state and respond to requests
  **Worker Processes:** Perform background tasks
  **Supervisor Processes:** Monitor and restart child processes
  **Registry Processes:** Keep track of named processes
  **Pool Processes:** Manage a pool of worker processes

  ## "Let It Crash" Philosophy

  Elixir embraces failures as normal occurrences:
  - Don't write defensive code everywhere
  - Let processes crash when they encounter unexpected states
  - Use supervisors to restart crashed processes
  - Isolate failures to prevent system-wide crashes
  - Design for failure recovery, not failure prevention

  ## Process Communication Patterns

  **Request/Response:** Send message, wait for reply
  **Cast:** Send message, don't wait for reply
  **Pub/Sub:** Broadcast messages to multiple subscribers
  **Pipeline:** Chain processes for data processing
  **State Machine:** Process changes behavior based on state
  """

  import Enlightenment

  def test_01_spawning_processes do
    # CONCEPT: Process Creation and Lightweight Concurrency
    #
    # spawn/1 creates a new Elixir process (not an OS thread).
    # These processes are incredibly lightweight and isolated,
    # making it practical to create thousands or millions of them.

    # spawn/1 creates a new process
    pid = spawn(fn -> :ok end)

    # PIDs are the process identifier
    assert_equal(Enlightenment.__(), is_pid(pid))

    # Process creation mechanics:
    #
    # spawn/1: Creates unlinked process
    # spawn_link/1: Creates linked process (failure propagates)
    # spawn_monitor/1: Creates monitored process (get notification on exit)
    #
    # Process characteristics:
    # - Each process has unique PID (Process Identifier)
    # - Processes are garbage collected when they exit
    # - Memory is isolated between processes
    # - No shared mutable state
    #
    # Lightweight nature:
    # - ~2KB initial memory footprint
    # - Creation takes ~1-3 microseconds
    # - Can create millions of processes
    # - BEAM VM manages them efficiently
    # - Pre-emptive scheduling ensures fairness
    #
    # Process scheduling:
    # - Each process gets reduction quota
    # - VM preemptively schedules processes
    # - No single process can monopolize CPU
    # - Automatic load balancing across cores
    #
    # Common spawn patterns:
    #
    # Fire-and-forget:
    # spawn(fn -> background_task() end)
    #
    # With communication:
    # parent = self()
    # spawn(fn ->
    #   result = expensive_computation()
    #   send(parent, {:result, result})
    # end)
    #
    # Process pools:
    # workers = for i <- 1..100 do
    #   spawn(fn -> worker_loop(i) end)
    # end
    #
    # The key insight: In Elixir, creating processes is so cheap
    # that you can create a process for each user, connection,
    # or task without worrying about resource constraints.
  end

  def test_02_self_process do
    # CONCEPT: Current Process Context
    #
    # Every piece of Elixir code runs within a process context.
    # self/0 returns the PID of the current process, which is
    # essential for message passing and process coordination.

    # self/0 returns the current process PID
    current_pid = self()

    assert_equal(Enlightenment.__(), is_pid(current_pid))

    # Process context fundamentals:
    #
    # Every Elixir code runs in a process:
    # - Interactive shell (iex) runs in a process
    # - Each test runs in its own process
    # - Web requests handled by separate processes
    # - Background tasks run in dedicated processes
    #
    # Uses of self/0:
    #
    # Message passing coordination:
    # parent = self()
    # child = spawn(fn ->
    #   result = do_work()
    #   send(parent, {:done, result})
    # end)
    #
    # Process registration:
    # Process.register(self(), :main_process)
    #
    # Process monitoring:
    # Process.monitor(self())  # Monitor current process
    #
    # Error handling:
    # Process.flag(:trap_exit, true)  # Configure current process
    #
    # Process identification in debugging:
    # IO.puts("Current process: #{inspect(self())}")
    #
    # Process hierarchy patterns:
    # defmodule ParentProcess do
    #   def start do
    #     parent_pid = self()
    #
    #     children = for i <- 1..5 do
    #       spawn(fn -> child_process(i, parent_pid) end)
    #     end
    #
    #     coordinate_children(children)
    #   end
    # end
    #
    # Context switching awareness:
    # When you spawn a process, self/0 in the new process
    # will return a different PID than the spawning process.
    #
    # Example:
    # IO.puts("Parent: #{inspect(self())}")  # #PID<0.123.0>
    # spawn(fn ->
    #   IO.puts("Child: #{inspect(self())}")  # #PID<0.124.0>
    # end)
    #
    # Process-local data:
    # Each process has its own:
    # - Process dictionary (Process.put/get)
    # - Mailbox for messages
    # - Stack and heap memory
    # - Process info (links, monitors, etc.)
  end

  def test_03_sending_messages do
    # CONCEPT: Asynchronous Message Passing
    #
    # Message passing is the foundation of Elixir's concurrency model.
    # send/2 delivers messages asynchronously, while receive blocks
    # until a matching message arrives in the mailbox.

    # Send messages with send/2
    parent = self()

    spawn(fn ->
      send(parent, {:hello, "from child"})
    end)

    # Receive messages with receive
    result =
      receive do
        {:hello, message} -> message
      after
        1000 -> "timeout"
      end

    assert_equal(Enlightenment.__(), result)

    # Message passing fundamentals:
    #
    # send/2 characteristics:
    # - Always returns the sent message
    # - Non-blocking (asynchronous)
    # - Copies data to recipient's mailbox
    # - Works across distributed nodes
    # - No confirmation of delivery
    #
    # receive characteristics:
    # - Blocks until matching message
    # - Pattern matches against mailbox
    # - Messages processed in arrival order
    # - Supports timeout with after clause
    # - Can be selective (skip non-matching messages)
    #
    # Message format conventions:
    #
    # Tagged tuples (most common):
    # send(pid, {:request, :get_status})
    # send(pid, {:response, :ok, data})
    # send(pid, {:error, :not_found})
    #
    # Atoms for simple signals:
    # send(pid, :start)
    # send(pid, :stop)
    # send(pid, :ping)
    #
    # Request/response pattern:
    # requester = self()
    # send(server_pid, {:request, requester, :get_data})
    #
    # receive do
    #   {:response, data} -> data
    #   {:error, reason} -> {:error, reason}
    # after
    #   5000 -> {:error, :timeout}
    # end
    #
    # Timeout patterns:
    #
    # With timeout:
    # receive do
    #   message -> handle_message(message)
    # after
    #   1000 -> handle_timeout()
    # end
    #
    # Without timeout (blocks forever):
    # receive do
    #   message -> handle_message(message)
    # end
    #
    # Zero timeout (check mailbox, don't wait):
    # receive do
    #   message -> handle_message(message)
    # after
    #   0 -> :no_messages
    # end
    #
    # Message copying semantics:
    # - Data is copied between processes
    # - No shared mutable state
    # - Large messages have performance cost
    # - Binary data optimized for sharing
    # - Atoms and small integers not copied
  end

  def test_04_process_mailbox do
    # CONCEPT: Process Mailbox and Message Ordering
    #
    # Each process has a mailbox that stores incoming messages.
    # Messages are delivered in FIFO order between any two specific
    # processes, but global ordering is not guaranteed.

    # Each process has a mailbox for messages
    parent = self()

    # Send multiple messages
    spawn(fn ->
      send(parent, :first)
      send(parent, :second)
      send(parent, :third)
    end)

    # Receive them in order
    messages = []

    msg1 =
      receive do
        msg -> msg
      end

    messages = [msg1 | messages]

    msg2 =
      receive do
        msg -> msg
      end

    messages = [msg2 | messages]

    msg3 =
      receive do
        msg -> msg
      end

    messages = [msg3 | messages]

    assert_equal(Enlightenment.__(), Enum.reverse(messages))

    # Mailbox characteristics:
    #
    # FIFO ordering guarantees:
    # - Messages from Process A to Process B maintain order
    # - Messages from different processes may interleave
    # - No global message ordering across system
    #
    # Mailbox implementation:
    # - Each process has private mailbox
    # - Messages stored in process heap
    # - Unbounded size (can cause memory issues)
    # - Pattern matching scans from oldest to newest
    #
    # Message delivery semantics:
    #
    # Between two processes:
    # Process A → Process B: [msg1, msg2, msg3]
    # Guaranteed to arrive in order: msg1, msg2, msg3
    #
    # From multiple processes:
    # Process A → Process C: [msg1, msg3]
    # Process B → Process C: [msg2, msg4]
    # Possible orderings: [msg1, msg2, msg3, msg4] or [msg1, msg3, msg2, msg4]
    #
    # Selective receive patterns:
    #
    # Process all messages:
    # defp drain_mailbox(acc \\ []) do
    #   receive do
    #     message -> drain_mailbox([message | acc])
    #   after
    #     0 -> Enum.reverse(acc)
    #   end
    # end
    #
    # Priority-based receive:
    # receive do
    #   {:priority, :high, msg} -> handle_high_priority(msg)
    #   {:priority, :medium, msg} -> handle_medium_priority(msg)
    #   {:priority, :low, msg} -> handle_low_priority(msg)
    # end
    #
    # Mailbox inspection (for debugging):
    # {:messages, messages} = Process.info(self(), :messages)
    # IO.inspect(messages, label: "Current mailbox")
    #
    # Mailbox size monitoring:
    # {:message_queue_len, len} = Process.info(pid, :message_queue_len)
    # if len > 1000, do: Logger.warn("Large mailbox: #{len} messages")
    #
    # Memory considerations:
    # - Large mailboxes consume memory
    # - Slow consumers can cause backpressure
    # - Monitor mailbox sizes in production
    # - Consider flow control mechanisms
  end

  def test_05_selective_receive do
    # CONCEPT: Pattern Matching in Message Handling
    #
    # receive blocks use pattern matching to selectively process
    # messages. This allows processes to handle different types
    # of messages appropriately and implement priority systems.

    parent = self()

    spawn(fn ->
      send(parent, {:priority, :low, "not important"})
      send(parent, {:priority, :high, "very important"})
      send(parent, {:priority, :medium, "somewhat important"})
    end)

    # Receive high priority message first
    high_priority =
      receive do
        {:priority, :high, message} ->
          message

        {:priority, _, _} ->
          receive do
            {:priority, :high, message} -> message
          end
      end

    assert_equal(Enlightenment.__(), high_priority)

    # Selective receive mechanics:
    #
    # Pattern matching process:
    # 1. Check first message against all patterns
    # 2. If match found, process message and remove from mailbox
    # 3. If no match, check next message
    # 4. Repeat until match found or timeout
    #
    # Message scanning behavior:
    # - Scans mailbox from oldest to newest
    # - Skipped messages remain in mailbox
    # - Can lead to mailbox buildup if patterns too specific
    #
    # Priority handling patterns:
    #
    # Simple priority system:
    # receive do
    #   {:urgent, msg} -> handle_urgent(msg)
    #   {:normal, msg} -> handle_normal(msg)
    #   {:low, msg} -> handle_low(msg)
    # end
    #
    # Nested priority handling:
    # receive do
    #   {:priority, :critical, msg} ->
    #     handle_critical(msg)
    #
    #   other_msg ->
    #     # Check for critical messages first
    #     receive do
    #       {:priority, :critical, msg} -> handle_critical(msg)
    #     after
    #       0 -> handle_other(other_msg)
    #     end
    # end
    #
    # Message type routing:
    # receive do
    #   {:http_request, method, path, body} ->
    #     handle_http_request(method, path, body)
    #
    #   {:database, :query, sql} ->
    #     handle_database_query(sql)
    #
    #   {:timer, :tick} ->
    #     handle_timer_tick()
    #
    #   unexpected ->
    #     Logger.warn("Unexpected message: #{inspect(unexpected)}")
    # end
    #
    # Conditional message processing:
    # receive do
    #   {:request, id, data} when is_integer(id) and id > 0 ->
    #     process_valid_request(id, data)
    #
    #   {:request, invalid_id, _data} ->
    #     {:error, {:invalid_id, invalid_id}}
    # end
    #
    # Performance considerations:
    # - Specific patterns first (more efficient)
    # - Avoid overly complex patterns
    # - Consider mailbox size with selective receive
    # - Use timeouts to prevent infinite blocking
    # - Monitor for unhandled message accumulation
    #
    # Anti-patterns to avoid:
    # ❌ Overly specific patterns causing message buildup
    # ❌ Missing catch-all patterns for unexpected messages
    # ❌ Deep nesting of receive blocks
    # ❌ Long-running operations in receive blocks
  end

  def test_06_process_links do
    # CONCEPT: Process Linking and Failure Propagation
    #
    # Links create bidirectional connections between processes.
    # When a linked process exits abnormally, the linked process
    # also exits, enabling fault-tolerant system design.

    # Processes can be linked - if one dies, the other dies too
    parent = self()

    child =
      spawn_link(fn ->
        send(parent, :child_started)
        Process.sleep(100)
      end)

    receive do
      :child_started -> :ok
    end

    # Check if processes are linked
    links = Process.info(self(), :links)[:links]
    assert_equal(Enlightenment.__(), child in links)

    # Process linking fundamentals:
    #
    # Link characteristics:
    # - Bidirectional connection
    # - Automatic failure propagation
    # - Can be created at spawn or later
    # - Multiple links per process allowed
    # - Links are not messages (no mailbox overhead)
    #
    # Link creation methods:
    # spawn_link/1: Create and link atomically
    # Process.link/1: Link to existing process
    #
    # Link types and behavior:
    #
    # Normal exit: :normal, :shutdown, {:shutdown, term}
    # - Linked processes not affected
    # - Process exits gracefully
    #
    # Abnormal exit: Any other reason
    # - Linked processes also exit with same reason
    # - Creates cascade failure
    # - Unless process traps exits
    #
    # Supervision tree pattern:
    # Supervisor
    # ├── Worker 1 (linked)
    # ├── Worker 2 (linked)
    # └── Worker 3 (linked)
    #
    # If Worker 2 crashes:
    # 1. Worker 2 exits abnormally
    # 2. Supervisor detects exit (via link)
    # 3. Supervisor restarts Worker 2
    # 4. System continues operating
    #
    # Link vs Monitor comparison:
    #
    # Links:
    # ✅ Bidirectional failure propagation
    # ✅ Automatic cleanup
    # ✅ Simple supervisor pattern
    # ❌ No exit reason information
    # ❌ No selective failure handling
    #
    # Monitors:
    # ✅ One-way observation
    # ✅ Detailed exit information
    # ✅ Selective error handling
    # ❌ Manual cleanup required
    # ❌ More complex patterns
    #
    # Common linking patterns:
    #
    # Parent-child relationship:
    # child = spawn_link(fn -> child_process() end)
    # # Parent exits if child crashes
    #
    # Worker pool:
    # workers = for i <- 1..5 do
    #   spawn_link(fn -> worker_loop(i) end)
    # end
    # # All workers linked to manager
    #
    # Cleanup coordination:
    # Process.flag(:trap_exit, true)
    # child = spawn_link(fn -> child_work() end)
    #
    # receive do
    #   {:EXIT, ^child, reason} ->
    #     cleanup_resources()
    #     handle_child_exit(reason)
    # end
    #
    # Breaking links:
    # Process.unlink(child_pid)  # Remove bidirectional link
    #
    # Link inspection:
    # {:links, linked_pids} = Process.info(self(), :links)
    # IO.inspect(linked_pids, label: "Linked processes")
  end

  def test_07_process_monitoring do
    # CONCEPT: Process Monitoring and Observation
    #
    # Monitoring allows one process to observe another without
    # being affected by its failure. This enables supervisors
    # and other coordination patterns.

    # Monitor a process to get notified when it exits
    child =
      spawn(fn ->
        Process.sleep(50)
        exit(:normal)
      end)

    ref = Process.monitor(child)

    # Wait for DOWN message
    result =
      receive do
        {:DOWN, ^ref, :process, ^child, reason} -> reason
      after
        1000 -> :timeout
      end

    assert_equal(Enlightenment.__(), result)

    # Monitoring fundamentals:
    #
    # Monitor characteristics:
    # - Unidirectional observation
    # - No failure propagation
    # - Detailed exit information
    # - Automatic cleanup
    # - Returns monitoring reference
    #
    # DOWN message format:
    # {:DOWN, monitor_ref, :process, pid, exit_reason}
    #
    # Monitor creation:
    # ref = Process.monitor(pid)  # Monitor existing process
    # {pid, ref} = spawn_monitor(fun)  # Spawn and monitor
    #
    # Exit reason interpretation:
    #
    # :normal - Process completed successfully
    # :shutdown - Graceful shutdown requested
    # {:shutdown, reason} - Shutdown with custom reason
    # :kill - Process was killed (Process.exit(pid, :kill))
    # :noproc - Process already dead when monitor set
    # other - Abnormal exit with specific reason
    #
    # Supervisor monitoring pattern:
    # defmodule SimpleSupervisor do
    #   def start_link(child_spec) do
    #     pid = spawn_link(fn -> supervisor_loop(child_spec) end)
    #     {:ok, pid}
    #   end
    #
    #   defp supervisor_loop(child_spec) do
    #     {child_pid, monitor_ref} = spawn_monitor(child_spec)
    #
    #     receive do
    #       {:DOWN, ^monitor_ref, :process, ^child_pid, reason} ->
    #         handle_child_exit(reason, child_spec)
    #         supervisor_loop(child_spec)  # Restart supervision
    #     end
    #   end
    #
    #   defp handle_child_exit(:normal, _), do: :ok
    #   defp handle_child_exit(:shutdown, _), do: :ok
    #   defp handle_child_exit({:shutdown, _}, _), do: :ok
    #   defp handle_child_exit(reason, child_spec) do
    #     Logger.error("Child exited abnormally: #{inspect(reason)}")
    #     # Could implement restart strategies here
    #   end
    # end
    #
    # Resource cleanup monitoring:
    # resource = acquire_resource()
    # worker_pid = spawn(fn -> use_resource(resource) end)
    # monitor_ref = Process.monitor(worker_pid)
    #
    # receive do
    #   {:DOWN, ^monitor_ref, :process, ^worker_pid, _reason} ->
    #     release_resource(resource)
    # end
    #
    # Multiple process coordination:
    # workers = for i <- 1..5 do
    #   {pid, ref} = spawn_monitor(fn -> worker(i) end)
    #   {pid, ref}
    # end
    #
    # wait_for_all_workers(workers, [])
    #
    # defp wait_for_all_workers([], results), do: results
    # defp wait_for_all_workers(workers, results) do
    #   receive do
    #     {:DOWN, ref, :process, pid, reason} ->
    #       remaining = List.keydelete(workers, {pid, ref}, 0)
    #       wait_for_all_workers(remaining, [{pid, reason} | results])
    #   end
    # end
    #
    # Demonitor:
    # Process.demonitor(monitor_ref)  # Stop monitoring
    # Process.demonitor(monitor_ref, [:flush])  # Stop and flush DOWN message
  end

  def test_08_process_exit_handling do
    # CONCEPT: Exit Signal Trapping and Graceful Shutdown
    #
    # Processes can trap exit signals to handle failures gracefully,
    # perform cleanup, and implement sophisticated error recovery
    # strategies instead of immediately crashing.

    # Handle process exits with trap_exit
    Process.flag(:trap_exit, true)

    child =
      spawn_link(fn ->
        exit(:custom_reason)
      end)

    result =
      receive do
        {:EXIT, ^child, reason} -> reason
      after
        1000 -> :timeout
      end

    assert_equal(Enlightenment.__(), result)

    # Clean up
    Process.flag(:trap_exit, false)

    # Exit trapping fundamentals:
    #
    # trap_exit flag effects:
    # - Convert exit signals to {:EXIT, pid, reason} messages
    # - Prevent automatic process termination
    # - Enable graceful shutdown and cleanup
    # - Allow selective restart logic
    #
    # EXIT message format:
    # {:EXIT, from_pid, exit_reason}
    #
    # Exit reasons and handling:
    #
    # :normal - Graceful completion
    # receive do
    #   {:EXIT, _pid, :normal} -> :ignore
    # end
    #
    # :shutdown, {:shutdown, term} - Requested shutdown
    # receive do
    #   {:EXIT, _pid, :shutdown} -> cleanup_and_exit()
    #   {:EXIT, _pid, {:shutdown, reason}} -> cleanup_and_exit(reason)
    # end
    #
    # :kill - Unconditional kill (cannot be trapped)
    # # Process will die immediately, no EXIT message
    #
    # Other reasons - Abnormal exits
    # receive do
    #   {:EXIT, pid, reason} ->
    #     Logger.error("Process #{inspect(pid)} crashed: #{inspect(reason)}")
    #     restart_process(pid)
    # end
    #
    # Supervisor exit handling pattern:
    # defmodule Supervisor do
    #   def start_link(children) do
    #     pid = spawn_link(fn -> init(children) end)
    #     {:ok, pid}
    #   end
    #
    #   defp init(children) do
    #     Process.flag(:trap_exit, true)
    #     start_children(children)
    #     supervisor_loop(children, [])
    #   end
    #
    #   defp supervisor_loop(child_specs, running_children) do
    #     receive do
    #       {:EXIT, pid, :normal} ->
    #         # Child completed normally
    #         remaining = List.keydelete(running_children, pid, 0)
    #         supervisor_loop(child_specs, remaining)
    #
    #       {:EXIT, pid, :shutdown} ->
    #         # Graceful shutdown
    #         remaining = List.keydelete(running_children, pid, 0)
    #         supervisor_loop(child_specs, remaining)
    #
    #       {:EXIT, pid, reason} ->
    #         # Abnormal exit - restart child
    #         Logger.warn("Child #{inspect(pid)} crashed: #{inspect(reason)}")
    #         child_spec = find_child_spec(pid, running_children, child_specs)
    #         new_pid = restart_child(child_spec)
    #         updated_children = List.keyreplace(running_children, pid, 0, new_pid)
    #         supervisor_loop(child_specs, updated_children)
    #     end
    #   end
    # end
    #
    # Graceful shutdown pattern:
    # defmodule Worker do
    #   def start_link do
    #     spawn_link(fn -> init() end)
    #   end
    #
    #   defp init do
    #     Process.flag(:trap_exit, true)
    #     state = initialize_state()
    #     worker_loop(state)
    #   end
    #
    #   defp worker_loop(state) do
    #     receive do
    #       {:work, task} ->
    #         new_state = process_task(task, state)
    #         worker_loop(new_state)
    #
    #       {:EXIT, _from, :shutdown} ->
    #         cleanup(state)
    #         exit(:shutdown)
    #
    #       {:EXIT, _from, reason} ->
    #         Logger.error("Unexpected exit: #{inspect(reason)}")
    #         cleanup(state)
    #         exit(reason)
    #     end
    #   end
    # end
    #
    # Exit signal types:
    # Process.exit(pid, :normal)      # Graceful exit
    # Process.exit(pid, :shutdown)    # Shutdown request
    # Process.exit(pid, :kill)        # Forceful kill (cannot be trapped)
    # Process.exit(pid, :custom)      # Custom exit reason
  end

  def test_09_process_registry do
    # CONCEPT: Process Naming and Global Registry
    #
    # The process registry allows processes to be identified by
    # names rather than PIDs, enabling location transparency and
    # service discovery patterns in distributed systems.

    # Register processes with names
    pid =
      spawn(fn ->
        receive do
          :stop -> :ok
        end
      end)

    Process.register(pid, :my_named_process)

    # Send to named process
    send(:my_named_process, :stop)

    # Check if it was registered
    assert_equal(Enlightenment.__(), Process.whereis(:my_named_process) == pid)

    # Process registry fundamentals:
    #
    # Global name registration:
    # - One name per process
    # - One process per name
    # - Names must be atoms
    # - Global across all nodes
    # - Automatic cleanup on process exit
    #
    # Registry operations:
    # Process.register(pid, name)  # Register process with name
    # Process.whereis(name)        # Find PID by name (nil if not found)
    # Process.registered()         # List all registered names
    # Process.unregister(name)     # Remove name registration
    #
    # Named process patterns:
    #
    # Singleton services:
    # defmodule DatabaseManager do
    #   def start_link do
    #     pid = spawn_link(fn -> init() end)
    #     Process.register(pid, :database_manager)
    #     {:ok, pid}
    #   end
    #
    #   def query(sql) do
    #     send(:database_manager, {:query, self(), sql})
    #     receive do
    #       {:result, data} -> {:ok, data}
    #       {:error, reason} -> {:error, reason}
    #     end
    #   end
    # end
    #
    # Service discovery:
    # defmodule ServiceRegistry do
    #   def register_service(name, pid) do
    #     case Process.whereis(name) do
    #       nil ->
    #         Process.register(pid, name)
    #         {:ok, :registered}
    #       _existing_pid ->
    #         {:error, :already_registered}
    #     end
    #   end
    #
    #   def find_service(name) do
    #     case Process.whereis(name) do
    #       nil -> {:error, :not_found}
    #       pid -> {:ok, pid}
    #     end
    #   end
    # end
    #
    # Dynamic naming patterns:
    # # User session processes
    # user_id = 123
    # session_name = String.to_atom("user_session_#{user_id}")
    # Process.register(pid, session_name)
    #
    # # Room/channel processes
    # room_id = "lobby"
    # room_name = String.to_atom("room_#{room_id}")
    # Process.register(pid, room_name)
    #
    # Registry limitations:
    # ❌ Global namespace conflicts
    # ❌ Atom table growth (atoms not garbage collected)
    # ❌ Single point of failure
    # ❌ No clustering support for dynamic names
    #
    # Alternative registries:
    #
    # Registry module (OTP 20+):
    # {:ok, _} = Registry.start_link(keys: :unique, name: :my_registry)
    # Registry.register(:my_registry, "user:123", user_data)
    # [{pid, user_data}] = Registry.lookup(:my_registry, "user:123")
    #
    # GenServer with via tuples:
    # GenServer.start_link(MyServer, [], name: {:via, Registry, {:my_registry, key}})
    #
    # Distributed alternatives:
    # - :global module for distributed naming
    # - :pg (process groups) for publish-subscribe
    # - Custom distributed registries
    #
    # Best practices:
    # ✅ Use descriptive names
    # ✅ Consider namespacing (prefixes)
    # ✅ Handle registration failures
    # ✅ Unregister when appropriate
    # ❌ Avoid dynamic atom creation in production
    # ❌ Don't rely on global registry for high-throughput systems
  end

  def test_10_process_info do
    # CONCEPT: Process Introspection and Runtime Information
    #
    # Process.info/1,2 provides comprehensive information about
    # process state, which is essential for debugging, monitoring,
    # and building process management tools.

    # Get information about processes
    pid =
      spawn(fn ->
        receive do
          :stop -> :ok
        end
      end)

    info = Process.info(pid)

    # Check some basic info
    assert_equal(Enlightenment.__(), is_list(info))

    assert_equal(Enlightenment.__(), info[:status] == :waiting)

    send(pid, :stop)

    # Process information categories:
    #
    # Basic process state:
    # Process.info(pid, :status)           # :running, :waiting, :runnable, :garbage_collecting, :suspended
    # Process.info(pid, :current_function) # {Module, function, arity} currently executing
    # Process.info(pid, :initial_call)     # {Module, function, arity} process started with
    # Process.info(pid, :registered_name)  # Atom name if registered, [] if not
    #
    # Memory information:
    # Process.info(pid, :memory)           # Total memory in bytes
    # Process.info(pid, :heap_size)        # Heap size in words
    # Process.info(pid, :stack_size)       # Stack size in words
    # Process.info(pid, :total_heap_size)  # Total heap including old generation
    #
    # Message queue:
    # Process.info(pid, :message_queue_len) # Number of messages in mailbox
    # Process.info(pid, :messages)         # List of messages (use carefully!)
    #
    # Process relationships:
    # Process.info(pid, :links)            # List of linked PIDs
    # Process.info(pid, :monitors)         # List of monitors set by process
    # Process.info(pid, :monitored_by)     # List of processes monitoring this one
    #
    # Scheduling information:
    # Process.info(pid, :reductions)       # Reduction count (execution units)
    # Process.info(pid, :priority)         # Process priority (:low, :normal, :high, :max)
    # Process.info(pid, :trap_exit)        # Boolean, true if trapping exits
    #
    # Error handling:
    # Process.info(pid, :error_handler)    # Module handling undefined functions
    # Process.info(pid, :last_calls)       # Last function calls (if enabled)
    #
    # Process monitoring patterns:
    #
    # Health check:
    # defmodule ProcessHealth do
    #   def check(pid) do
    #     case Process.info(pid) do
    #       nil ->
    #         {:error, :dead}
    #       info ->
    #         memory = info[:memory]
    #         queue_len = info[:message_queue_len]
    #         status = info[:status]
    #
    #         cond do
    #           memory > 100_000_000 -> {:warning, :high_memory, memory}
    #           queue_len > 1000 -> {:warning, :large_mailbox, queue_len}
    #           status == :suspended -> {:warning, :suspended}
    #           true -> {:ok, :healthy}
    #         end
    #     end
    #   end
    # end
    #
    # Process debugging:
    # defmodule ProcessDebugger do
    #   def debug_process(pid) do
    #     info = Process.info(pid)
    #
    #     IO.puts("=== Process Debug Info ===")
    #     IO.puts("PID: #{inspect(pid)}")
    #     IO.puts("Status: #{info[:status]}")
    #     IO.puts("Current function: #{inspect(info[:current_function])}")
    #     IO.puts("Memory: #{info[:memory]} bytes")
    #     IO.puts("Message queue: #{info[:message_queue_len]} messages")
    #     IO.puts("Links: #{inspect(info[:links])}")
    #     IO.puts("Reductions: #{info[:reductions]}")
    #   end
    # end
    #
    # System-wide process monitoring:
    # defmodule SystemMonitor do
    #   def scan_processes do
    #     Process.list()
    #     |> Enum.map(fn pid ->
    #       case Process.info(pid, [:memory, :message_queue_len, :current_function]) do
    #         nil -> nil
    #         info -> {pid, info}
    #       end
    #     end)
    #     |> Enum.reject(&is_nil/1)
    #     |> Enum.sort_by(fn {_pid, info} -> info[:memory] end, :desc)
    #   end
    #
    #   def find_memory_hogs(threshold \\ 50_000_000) do
    #     scan_processes()
    #     |> Enum.filter(fn {_pid, info} -> info[:memory] > threshold end)
    #   end
    # end
    #
    # Performance considerations:
    # ⚠️ Process.info/1 is expensive (returns all info)
    # ✅ Process.info/2 is cheaper (specific info only)
    # ⚠️ Getting :messages can be very expensive
    # ✅ Cache info for repeated access
    # ⚠️ Don't call in tight loops
  end

  def test_11_simple_server_process do
    # CONCEPT: Stateful Server Processes and Message Loops
    #
    # Server processes maintain state through recursive function calls
    # and handle different types of messages. This pattern forms the
    # foundation of GenServer and other OTP behaviors.

    # A simple server that maintains state
    defmodule Counter do
      def start_link(initial_count) do
        spawn_link(fn -> loop(initial_count) end)
      end

      def get(pid) do
        send(pid, {:get, self()})

        receive do
          {:count, count} -> count
        end
      end

      def increment(pid) do
        send(pid, :increment)
      end

      defp loop(count) do
        receive do
          {:get, caller} ->
            send(caller, {:count, count})
            loop(count)

          :increment ->
            loop(count + 1)
        end
      end
    end

    # Start the counter
    counter = Counter.start_link(0)

    # Test it
    assert_equal(Enlightenment.__(), Counter.get(counter))

    Counter.increment(counter)
    Counter.increment(counter)

    assert_equal(Enlightenment.__(), Counter.get(counter))

    # Server process pattern fundamentals:
    #
    # Core components:
    # 1. State management through function parameters
    # 2. Recursive message loop (tail call optimization)
    # 3. Pattern matching on message types
    # 4. State transformation for each message
    # 5. Client API functions for user interaction
    #
    # Message loop structure:
    # defp loop(state) do
    #   receive do
    #     {:request_type1, params} ->
    #       new_state = handle_request1(params, state)
    #       loop(new_state)
    #
    #     {:request_type2, caller, params} ->
    #       {response, new_state} = handle_request2(params, state)
    #       send(caller, response)
    #       loop(new_state)
    #   end
    # end
    #
    # Request/response patterns:
    #
    # Synchronous (caller waits):
    # def get_value(server_pid) do
    #   send(server_pid, {:get_value, self()})
    #   receive do
    #     {:value, value} -> value
    #   after
    #     5000 -> {:error, :timeout}
    #   end
    # end
    #
    # Asynchronous (fire and forget):
    # def set_value(server_pid, value) do
    #   send(server_pid, {:set_value, value})
    #   :ok
    # end
    #
    # Advanced server patterns:
    #
    # Stateful calculator:
    # defmodule Calculator do
    #   def start_link(initial_value \\ 0) do
    #     {:ok, spawn_link(fn -> loop(initial_value) end)}
    #   end
    #
    #   def add(pid, value), do: call(pid, {:add, value})
    #   def multiply(pid, value), do: call(pid, {:multiply, value})
    #   def get(pid), do: call(pid, :get)
    #   def reset(pid), do: cast(pid, :reset)
    #
    #   defp call(pid, message) do
    #     ref = make_ref()
    #     send(pid, {message, self(), ref})
    #     receive do
    #       {^ref, response} -> response
    #     after
    #       5000 -> {:error, :timeout}
    #     end
    #   end
    #
    #   defp cast(pid, message) do
    #     send(pid, {message})
    #     :ok
    #   end
    #
    #   defp loop(value) do
    #     receive do
    #       {{:add, amount}, caller, ref} ->
    #         new_value = value + amount
    #         send(caller, {ref, {:ok, new_value}})
    #         loop(new_value)
    #
    #       {{:multiply, factor}, caller, ref} ->
    #         new_value = value * factor
    #         send(caller, {ref, {:ok, new_value}})
    #         loop(new_value)
    #
    #       {:get, caller, ref} ->
    #         send(caller, {ref, value})
    #         loop(value)
    #
    #       {:reset} ->
    #         loop(0)
    #     end
    #   end
    # end
    #
    # Resource manager pattern:
    # defmodule ResourcePool do
    #   def start_link(resources) do
    #     state = %{available: resources, borrowed: MapSet.new()}
    #     {:ok, spawn_link(fn -> loop(state) end)}
    #   end
    #
    #   defp loop(%{available: [], borrowed: borrowed} = state) do
    #     receive do
    #       {:checkout, caller, ref} ->
    #         send(caller, {ref, {:error, :no_resources}})
    #         loop(state)
    #
    #       {:checkin, resource} when resource in borrowed ->
    #         new_state = %{
    #           available: [resource],
    #           borrowed: MapSet.delete(borrowed, resource)
    #         }
    #         loop(new_state)
    #     end
    #   end
    #
    #   defp loop(%{available: [resource | rest], borrowed: borrowed} = state) do
    #     receive do
    #       {:checkout, caller, ref} ->
    #         send(caller, {ref, {:ok, resource}})
    #         new_state = %{
    #           available: rest,
    #           borrowed: MapSet.put(borrowed, resource)
    #         }
    #         loop(new_state)
    #
    #       # ... handle checkin
    #     end
    #   end
    # end
    #
    # Error handling in servers:
    # defp loop(state) do
    #   receive do
    #     message ->
    #       try do
    #         new_state = handle_message(message, state)
    #         loop(new_state)
    #       rescue
    #         error ->
    #           Logger.error("Server error: #{inspect(error)}")
    #           loop(state)  # Continue with old state
    #       end
    #   end
    # end
    #
    # This pattern is formalized in GenServer behavior!
  end

  def test_12_process_dictionary do
    # CONCEPT: Process-Local Storage and State Management
    #
    # The process dictionary provides process-local storage that
    # persists across function calls within the same process.
    # While convenient, it should be used judiciously as it introduces
    # implicit state that can make debugging difficult.

    # Each process has a process dictionary for storing data
    Process.put(:my_key, "my_value")

    value = Process.get(:my_key)
    assert_equal(Enlightenment.__(), value)

    # Get with default
    default_value = Process.get(:nonexistent, "default")
    assert_equal(Enlightenment.__(), default_value)

    # Process dictionary fundamentals:
    #
    # Storage characteristics:
    # - Key-value store per process
    # - Keys must be atoms or references
    # - Values can be any Elixir term
    # - Survives across function calls
    # - Dies with the process
    # - Not copied in spawn (each process has its own)
    #
    # Process dictionary operations:
    # Process.put(key, value)      # Store value
    # Process.get(key)             # Retrieve value (nil if not found)
    # Process.get(key, default)    # Retrieve with default
    # Process.get_keys()           # List all keys
    # Process.get_keys(value)      # Keys that have specific value
    # Process.delete(key)          # Remove key-value pair
    # Process.erase()              # Clear entire dictionary
    #
    # Common use cases:
    #
    # Request context (web applications):
    # defmodule WebContext do
    #   def set_user(user), do: Process.put(:current_user, user)
    #   def get_user(), do: Process.get(:current_user)
    #   def set_request_id(id), do: Process.put(:request_id, id)
    #   def get_request_id(), do: Process.get(:request_id)
    # end
    #
    # # In controller
    # WebContext.set_user(current_user)
    # WebContext.set_request_id(UUID.generate())
    #
    # # Deep in business logic
    # user = WebContext.get_user()
    # request_id = WebContext.get_request_id()
    # Logger.info("User #{user.id} action", request_id: request_id)
    #
    # Debugging and tracing:
    # defmodule TraceCollector do
    #   def start_trace do
    #     Process.put(:trace_events, [])
    #   end
    #
    #   def add_event(event) do
    #     events = Process.get(:trace_events, [])
    #     Process.put(:trace_events, [event | events])
    #   end
    #
    #   def get_trace do
    #     Process.get(:trace_events, []) |> Enum.reverse()
    #   end
    # end
    #
    # Configuration and flags:
    # defmodule ProcessFlags do
    #   def enable_debug(), do: Process.put(:debug_mode, true)
    #   def disable_debug(), do: Process.put(:debug_mode, false)
    #   def debug_enabled?(), do: Process.get(:debug_mode, false)
    #
    #   def set_log_level(level), do: Process.put(:log_level, level)
    #   def get_log_level(), do: Process.get(:log_level, :info)
    # end
    #
    # Caching (with caution):
    # defmodule ProcessCache do
    #   def cached_expensive_call(args) do
    #     cache_key = {:expensive_call, args}
    #     case Process.get(cache_key) do
    #       nil ->
    #         result = expensive_call(args)
    #         Process.put(cache_key, result)
    #         result
    #       cached_result ->
    #         cached_result
    #     end
    #   end
    # end
    #
    # Anti-patterns and warnings:
    #
    # ❌ Overuse as implicit global state:
    # # Hard to test and debug
    # def some_function() do
    #   secret_config = Process.get(:secret_config)  # Where did this come from?
    #   # ... use config
    # end
    #
    # ❌ Large data storage:
    # # Process dictionary not optimized for large data
    # Process.put(:large_dataset, huge_list)  # Better in process state
    #
    # ❌ Cross-process assumptions:
    # # Process dictionary is not shared
    # spawn(fn ->
    #   value = Process.get(:parent_value)  # Always nil!
    # end)
    #
    # Best practices:
    # ✅ Use for process-scoped context
    # ✅ Document dictionary usage clearly
    # ✅ Keep values small
    # ✅ Use descriptive keys
    # ✅ Clean up when no longer needed
    # ✅ Consider explicit parameters instead
    #
    # Alternative patterns:
    #
    # Explicit state passing:
    # def process_request(request, context) do
    #   # context contains user, request_id, etc.
    #   handle_request(request, context)
    # end
    #
    # Agent for shared state:
    # {:ok, agent} = Agent.start_link(fn -> %{} end)
    # Agent.put(agent, :key, value)
    # Agent.get(agent, :key)
    #
    # GenServer state:
    # defmodule StatefulServer do
    #   use GenServer
    #
    #   def handle_call(:get_context, _from, state) do
    #     {:reply, state.context, state}
    #   end
    # end
  end
end
