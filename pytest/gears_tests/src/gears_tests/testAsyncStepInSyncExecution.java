package gears_tests;

import java.io.Serializable;

import gears.ExecutionMode;
import gears.GearsBuilder;
import gears.GearsFuture;
import gears.readers.CommandReader;

public class testAsyncStepInSyncExecution {
	public static void main() {
		CommandReader reader = new CommandReader().setTrigger("test");
		
		GearsBuilder.CreateGearsBuilder(reader).
		asyncMap(r->{
			GearsFuture<Serializable> f = new GearsFuture<Serializable>();
			return f;
		}).register(ExecutionMode.SYNC);
		
	}
}
