package event;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPool;
import flixel.util.FlxSignal;

class MultiLock
{
    /**
     * Called every time the final lock is removed
     */
    public final onUnlock = new FlxSignal();
  
    /**
     * Called every time the final lock is removed
     */
    public final onLock = new FlxSignal();
    
    final locks = new Array<Lock>();
    
    public function new (onUnlock:()->Void)
    {
        this.onUnlock.add(onUnlock);
    }
    
    /**
     * Whether there are any active locks
     */
    public function isLocked()
    {
        return locks.length > 0;
    }
    
    /**
     * The number of active locks
     */
    public function length()
    {
        return locks.length;
    }
    
    /**
     * Adds a lock and returns the function that will remove said lock
     * @param   logId  Used for debugging
     * @return The function that removes this lock
     */
    public function add(?logId:String):()->Void
    {
        final lock = Lock.get(logId);
        locks.push(lock);
        if (locks.length == 1)
            onLock.dispatch();
        
        return function ()
        {
            if (locks.contains(lock) == false)
                throw 'Already removed lock: ${lock.logId}';
            
            locks.remove(lock);
            lock.put();
            
            if (locks.length == 0)
                onUnlock.dispatch();
        }
    }
    
    public function toString()
    {
        return locks.map((l)->l.logId).toString();
    }
}

private class Lock implements IFlxDestroyable
{
    static final pool = new FlxPool<Lock>(Lock.new);
    
    static var nextId = 0;
    
    public var logId:Null<String>;
    
    function new() {}
    
    public function init(?logId:String)
    {
        this.logId = logId ?? 'lock-$nextId';
        nextId++;
        return this;
    }
    
    public function destroy() { logId = null; }
    
    public function put() pool.putUnsafe(this);
    
    static public function get(?logId)
    {
        return pool.get().init(logId);
    }
}