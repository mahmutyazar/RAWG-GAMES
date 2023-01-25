
# RAWG GAMES

This application has been developed as final project of **Simpra iOS Swift Bootcamp** that carried out by [patika.dev](patika.dev) platform on December 2022 - January 2023.

<kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/1.png" width="160" height="345"/></kbd> <kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/2.png" width="160" height="345"/></kbd> <kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/3.png" width="160" height="345"/></kbd> <kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/4.png" width="160" height="345"/></kbd> <kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/5.png" width="160" height="345"/></kbd> <kbd><img src="https://github.com/mahmutyazar/RAWG-GAMES/blob/main/Images/6.png" width="160" height="345"/></kbd>

### TECHNICAL FEATURES

- MVVM Design Pattern
- CoreData
- Image cache
- Local Notification
- Localization
- Internet Manager
- AutoLayout

### UI 
- UITABLEVIEW
- UITABLEVIEWCELL
- UINAVIGATIONCONTROLLER
- UISEARCHBAR
- UISEGMENTEDCONTROL
- UITABBARCONTROLLER
- UIANIMATIONVİEW

### DEPENDENCIES
 - Alamofire
 - Kingfisher
 - Lottie

### HOME SCREEN

- At the beginning, a very stylish Activity Indicator welcomes you till all the data fetched from the service.
- You will access random 30 games each launch.
- Each game has a photo, rate and date of release.
- You can use Search Bar to take a look to thousands of games. Results are provided by API.
- You can sort video games by clicking segmented control on the top-right corner of the screen, according to alphabetic order or rate.
- You can reach game details by clicking each row on the table. On detail screen, there is also a button that allows you to add game to your favorites list.
- When you tap favorite button, Local Notification Manager send you a notification.
- As a difference from main page, on the Detail screen you can see a brief explanation about the game.

### FAVORITES SCREEN

- You can see all the games that you added to your favorites list on the previous Detail page. If you turn back and tap the "heart" button again, you can see the game is removed from the list.
- You can also swipe right to delete game from list.
- There's also a "trash" button on the top-right corner of the screen that allows you to delete all favorites games at once.

### NOTES SCREEN

- You can take notes about your favorites games, scores or achievements etc. on the Notes page. 
- To add a new note, you can tap on the "+" button on the bottom-right corner of the screen.
- On note-take screen, you can insert your title and your note on title text field and description text view.
- You **can not** leave the screen until you have finished editing.
- You can edit a note that already taken before by tapping each row on the table.
- You can delete your note by swiping right on the table, or tapping on the trash button on the note-take screen.
- If you want to delete all your notes at once, you can tap on the trash button on the top-right corner of the screen.

### DETAILS

- As default, the application fetches all the data from server. But in case of disconnetcion, it uses the data that cached before.
- In case of disconnetcion, you can just see main details of games on the main page. You must be connected to the internet to see the game details.
- On the version 1.0 you can use the Search Bar only if you're online.
- The application language is English as default. You can also use the application in Turkish.


## API USAGE

#### Get all 

```http
  GET /api/games
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | API Key. |

#### Get Items

```http
  GET /api/games/{id}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key` | `string` | API Key. |
| `id`      | `integer` | ID value|

#### Search

```http
  GET /api/games/search
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key` | `string` | API Key. |
| `keyword`      | `string` | Text to search|

  

