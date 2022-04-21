# Endless word-game

# Set correct answer:
$answer = "tree"

# Start an infinite loop:
While ($true) {
    Try {
        # Ask for a word
        $guess = Read-Host "Guess a word"
        
        # Check if answer is correct
        if ($guess -like $answer)
        {
            # Generate an error if 
            Throw # This will send us to the Catch segment
        }
        # If an error was thrown we will never get this far
        write-host "You guessed wrong"
    }
    Catch {
        # Print message
        Write-Host "That was correct!"

        # The keyword Continue will take us back to the top of the loop
        # meaning that the game will never end.
        Continue
        # Using Break instead of continue will state that the loop is done
        # and the game will end.
    }
    Finally {
        # this code will execute no matter if there were an error or not
        Write-Host "--------------------------------"   
    }
}

Write-host "Game Over"