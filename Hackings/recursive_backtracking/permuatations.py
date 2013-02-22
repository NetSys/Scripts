#!/usr/bin/env python

def permute(a):
  helper([], a)

def helper(chosen, choices):
  if choices == []:
    print chosen
    return

  for i, c in enumerate(choices):
    # Choose first element
    new_chosen = chosen + [c]
    new_choices = choices[0:i] + choices[i+1:]
    helper(new_chosen, new_choices)

permute([1,2,3,4,5])
