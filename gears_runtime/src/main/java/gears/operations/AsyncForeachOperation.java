package gears.operations;

import java.io.Serializable;

import gears.GearsFuture;

public interface AsyncForeachOperation<I extends Serializable> extends Serializable {

	public GearsFuture<I> foreach(I record) throws Exception;

}
