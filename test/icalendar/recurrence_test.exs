defmodule ICalendar.RecurrenceTest do
  use ExUnit.Case

  test "daily reccuring event with until" do
    events =
      """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      RRULE:FREQ=DAILY;UNTIL=20151231T083000Z
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
      """
      |> ICalendar.from_ics()
      |> Enum.map(fn event ->
        recurrences =
          ICalendar.Recurrence.get_recurrences(event)
          |> Enum.to_list()

        [event | recurrences]
      end)
      |> List.flatten()

    assert events |> Enum.count() == 8

    [event | events] = events
    assert event.dtstart == ~U[2015-12-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-25 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-26 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-27 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-28 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-29 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-30 08:30:00Z]
    [event] = events
    assert event.dtstart == ~U[2015-12-31 08:30:00Z]
  end

  test "daily reccuring event with count" do
    events =
      """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      RRULE:FREQ=DAILY;COUNT=3
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
      """
      |> ICalendar.from_ics()
      |> Enum.map(fn event ->
        recurrences =
          ICalendar.Recurrence.get_recurrences(event)
          |> Enum.to_list()

        [event | recurrences]
      end)
      |> List.flatten()

    assert events |> Enum.count() == 3

    [event | events] = events
    assert event.dtstart == ~U[2015-12-24 08:30:00Z]
    [event | _events] = events
    assert event.dtstart == ~U[2015-12-25 08:30:00Z]
  end

  test "monthly reccuring event with until" do
    events =
      """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      RRULE:FREQ=MONTHLY;UNTIL=20160624T083000Z
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
      """
      |> ICalendar.from_ics()
      |> Enum.map(fn event ->
        recurrences =
          ICalendar.Recurrence.get_recurrences(event)
          |> Enum.to_list()

        [event | recurrences]
      end)
      |> List.flatten()

    assert events |> Enum.count() == 7

    [event | events] = events
    assert event.dtstart == ~U[2015-12-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-01-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-02-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-03-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-04-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-05-24 08:30:00Z]
    [event] = events
    assert event.dtstart == ~U[2016-06-24 08:30:00Z]
  end

  test "weekly reccuring event with until" do
    events =
      """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      RRULE:FREQ=WEEKLY;UNTIL=20160201T083000Z
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
      """
      |> ICalendar.from_ics()
      |> Enum.map(fn event ->
        recurrences =
          ICalendar.Recurrence.get_recurrences(event)
          |> Enum.to_list()

        [event | recurrences]
      end)
      |> List.flatten()

    assert events |> Enum.count() == 6

    [event | events] = events
    assert event.dtstart == ~U[2015-12-24 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2015-12-31 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-01-07 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-01-14 08:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2016-01-21 08:30:00Z]
    [event] = events
    assert event.dtstart == ~U[2016-01-28 08:30:00Z]
  end

  test "exdates not included in reccuring event with until and byday, ignoring invalid byday value" do
    events =
      """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART:20200903T143000Z
      DTEND:20200903T153000Z
      RRULE:FREQ=WEEKLY;WKST=SU;UNTIL=20201028T045959Z;INTERVAL=2;BYDAY=TH,WE,AD
      EXDATE:20200917T143000Z
      EXDATE:20200916T143000Z
      SUMMARY:work!
      END:VEVENT
      END:VCALENDAR
      """
      |> ICalendar.from_ics()
      |> Enum.map(fn event ->
        recurrences =
          ICalendar.Recurrence.get_recurrences(event)
          |> Enum.to_list()

        [event | recurrences]
      end)
      |> List.flatten()

    assert events |> Enum.count() == 5

    [event | events] = events
    assert event.dtstart == ~U[2020-09-03 14:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2020-10-01 14:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2020-09-30 14:30:00Z]
    [event | events] = events
    assert event.dtstart == ~U[2020-10-15 14:30:00Z]
    [event] = events
    assert event.dtstart == ~U[2020-10-14 14:30:00Z]
  end
end
