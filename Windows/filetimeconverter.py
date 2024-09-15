import datetime

def filetime_to_dt(ft):
    """Convert Windows FILETIME to Python datetime."""
    EPOCH_AS_FILETIME = 116444736000000000  # January 1, 1970 as FILETIME
    HUNDREDS_OF_NANOSECONDS = 10000000

    # Convert FILETIME to seconds since the Unix epoch
    seconds_since_epoch = (ft - EPOCH_AS_FILETIME) // HUNDREDS_OF_NANOSECONDS
    
    # Create a datetime object
    return datetime.datetime.utcfromtimestamp(seconds_since_epoch)

# Example usage
filetime = 133688308967300298  # Replace with your FILETIME value
dt = filetime_to_dt(filetime)

print(f"FILETIME: {filetime}")
print(f"Human-readable UTC time: {dt}")
print(f"Human-readable local time: {dt.astimezone()}")

# Convert all process start times from the incident report
process_start_times = [
    133688308967300298,
    133688309034977815,
    133688314187527535,
    133688314130335441
]

print("\nAll process start times:")
for i, ft in enumerate(process_start_times, 1):
    dt = filetime_to_dt(ft)
    print(f"Process {i}:")
    print(f"  FILETIME: {ft}")
    print(f"  UTC time: {dt}")
    print(f"  Local time: {dt.astimezone()}")
    print()