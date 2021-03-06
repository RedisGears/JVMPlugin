package gears_tests;

import java.io.IOException;
import gears.ExecutionMode;
import gears.GearsBuilder;
import gears.readers.KeysReader;
import gears.records.KeysReaderRecord;

public class testRegistersSurviveRestart {
	public static void main() throws IOException {
		KeysReader reader = new KeysReader();
		new GearsBuilder(reader).
		filter(r->{
			return !((KeysReaderRecord)r).getKey().contains("NumOfKeys");
		}).
		foreach(r->{
			KeysReaderRecord kr = ((KeysReaderRecord)r);
			String incr;
			if(kr.getEvent().equals("del")) {
				incr = "-1";
			}else {
				incr = "1";
			}
			GearsBuilder.execute("incrby", String.format("NumOfKeys{%s}", GearsBuilder.hashtag()), incr);
		}).
		register(ExecutionMode.ASYNC_LOCAL);
	}
}
