package com.mobilink.SubProcess;

/*
 * Created on 01 August, 2010
 */

/**
 * @author Sheril
 *
 * This queue stores the data in FIFO mechanism
 */

import java.util.*;

public class PriorityQueue
  extends AbstractList
     {

  private final static int DEFAULT_PRIORITY_COUNT = 10;

  private List queue[];

  public PriorityQueue() {
    this(DEFAULT_PRIORITY_COUNT);
  }

  public PriorityQueue(Collection col) {
    this(col, DEFAULT_PRIORITY_COUNT);
  }

  public PriorityQueue(int count) {
    this(null, count);
  }

  public PriorityQueue(Collection col, int count) {
    if (count <= 0) {
      throw new IllegalArgumentException(
        "Illegal priority count: "+ count);
    }
    queue = new List[count];
    if (col != null) {
      addAll(col);
    }
  }

  /**
   * Returns trueif this list contains the specified element.
   *
   * @param elem element whose presence in this List is to be tested.
   * @return  true if the specified element is present;
   *		  false otherwise.
   */
  public boolean contains(Object elem) {
	return indexOf(elem) >= 0;
  }


  /**
   * Returns trueif the specified element is added properly
   *
   * @param elem element which needs to be added.
   * @return  true if the specified element is added properly;
   *		  false otherwise.
   */
public boolean add(Object element) {
    insert(element);
    return true;
  }

/**
 * Insert the specified element in the queue
 *
 * @param elem element which needs to be inserted.
 */

  public void insert(Object element) {

	    if (queue[0] == null) {
	      queue[0] = new LinkedList();
	    }
	    queue[0].add(element);
	    modCount++;
	  }

  /**
   * Returns the first/last inserted element in the queue
   *
   *
   */
  public Object getFirst() {
    return iterator().next();
  }

  /**
   * Returns the element in the specified index
   *
   */
  public Object get(int index) {
  if (index < 0) {
    throw new IllegalArgumentException(
      "Illegal index: "+ index);
  }
  Iterator iter = iterator();
  int pos = 0;
    while (iter.hasNext()) {
      Object obj = iter.next();
      if (pos == index) {
      return obj;
      } else
      {
        pos++;
    }
  }
  return null;
  }

  /**
   * Removes the oldest element and returns it
   *
   * @return  the element that has been removed from the queue
   */
  public Object removeFirst() {
    Iterator iter = iterator();
    Object obj = iter.next();
    iter.remove();
    return obj;
  }

  /**
   * Returns the present size of the queue
   *
   * @return  the size of the queue
   */
  public int size() {
    int size = 0;
    for (int i=0, n=queue.length; i<n; i++) {
      if (queue[i] != null) {
        size += queue[i].size();
      }
    }
    return size;
  }

  /**
   * Returns the Iterator of the queue
   *
   */
  public Iterator iterator() {
	    Iterator iter = new Iterator() {
	      int expectedModCount = modCount;
	      int priority = queue.length - 1;
	      int count = 0;
	      int size = size();

	      // Used to prevent successive remove() calls
	      int lastRet = -1;

	      Iterator tempIter;

	      // Get iterator for highest priority
	      {
	        if (queue[priority] == null) {
	          tempIter = null;
	        } else {
	          tempIter = queue[priority].iterator();
	        }
	      }

	      private final void checkForComodification() {
	        if (modCount != expectedModCount) {
	          throw new ConcurrentModificationException();
	        }
	      }

	      public boolean hasNext() {
	        return count != size();
	      }

	      public Object next() {
	        while (true) {
	          if ((tempIter != null) && (
	                               tempIter.hasNext())) {
	            Object next = tempIter.next();
	            checkForComodification();
	            lastRet = count++;
	            return next;
	          } else {
	            // Get next iterator
	            if (--priority < 0) {
	              checkForComodification();
	              throw new NoSuchElementException();
	            } else {
	              if (queue[priority] == null) {
	                tempIter = null;
	              } else {
	                tempIter = queue[priority].iterator();
	              }
	            }
	          }
	        }
	      }

	      public void remove() {
	        if (lastRet == -1) {
	          throw new IllegalStateException();
	        }
	        checkForComodification();

	        tempIter.remove();
	        count--;
	        lastRet = -1;
	        expectedModCount = modCount;
	      }
	    };
	    return iter;
	  }


}
