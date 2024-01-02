//
//  ToDoListTableViewController.swift
//  My-ToDoList
//



import UIKit

struct ToDo{
    var description: String
    var name: String
    var categorie: String
}



class CheckBoxTableViewCell: UITableViewCell {
    let checkBox = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCheckBox()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCheckBox()
    }

    private func configureCheckBox() {
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)

        contentView.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    @objc private func checkBoxTapped() {
        checkBox.isSelected.toggle()
    }
}














class ToDoListTableViewController: UITableViewController {
    
    var todoDictionary: [String: [ToDo]] = [:]

    
    

    let sb = UIStoryboard(name: "Main", bundle: nil)
          
        override func viewDidLoad() {
            super.viewDidLoad()
            
         
              
            self.navigationController?.navigationBar.barTintColor = UIColor.brown
              
            self.navigationItem.title = "My To-Do List"
              
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickedAdd))
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clickeddel))
            navigationItem.rightBarButtonItems = [deleteButton,addButton]
              
             
            addButton.tintColor = UIColor.blue
            deleteButton.tintColor = UIColor.blue
            
           
            updateTodoDictionary()
            

            
            
        }
    
    
    func updateTodoDictionary() {
          todoDictionary.removeAll()

          for todo in TodoList {
              if var categoryTodos = todoDictionary[todo.categorie] {
                  categoryTodos.append(todo)
                  todoDictionary[todo.categorie] = categoryTodos
              } else {
                  todoDictionary[todo.categorie] = [todo]
              }
          }
      }

    
    
    
    
    
      
      
        @IBAction func clickedButtonShow(_ sender: Any) {
            let secondVC = sb.instantiateViewController(identifier: "SecondVC")
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
          
    
    @objc func clickeddel() {
        let alertController = UIAlertController(title: "Quelle tâche voulez-vous supprimez ? ", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nom de la tache"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            if let nom = alertController.textFields?.first?.text{
               removeToDo(withName: nom)
            }
        }
        alertController.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            print("L'utilisateur a annulé la saisie.")
        }
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
        
    }
        
    @objc func clickedAdd() {
        let alertController = UIAlertController(title: "Remplissez les informations", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Nom de la tache"
        }

        alertController.addTextField { textField in
            textField.placeholder = "Description"
        }

        alertController.addTextField { textField in
            textField.placeholder = "Date"
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            if let nom = alertController.textFields?[0].text,
               let description = alertController.textFields?[1].text,
               let date = alertController.textFields?[2].text {
                print("Nom : \(nom), Description : \(description), Date : \(date)")
                let todo = ToDo(description: description, name: nom, categorie: date)
                TodoList.append(todo)
                // Update the dictionary and reload the table
                                updateTodoDictionary()
                                tableView.reloadData()


            }
        }
        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            print("L'utilisateur a annulé la saisie.")
        }
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    
    
    
    
    
    
    var TodoList = [
        ToDo(description: "faire la vaiselle ce soir", name:"vaiselle", categorie: "today"),
        ToDo(description: "faire les courses demain matin", name:"course", categorie: "tomorow"),
    ]
    
    func removeToDo(withName name: String) {
        if let index = TodoList.firstIndex(where: { $0.name == name }) {
            TodoList.remove(at: index)
            tableView.reloadData()
            
        }
        
        // Update the dictionary and reload the table
                        updateTodoDictionary()
                        tableView.reloadData()

    }
    
    
    
    

   
    

    override func numberOfSections(in tableView: UITableView) -> Int {
            // Return the number of categories
            return todoDictionary.keys.count
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of todos in the specific category
            let categories = Array(todoDictionary.keys)
            let category = categories[section]
            return todoDictionary[category]?.count ?? 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! CheckBoxTableViewCell

            let categories = Array(todoDictionary.keys)
            let category = categories[indexPath.section]

            if let todosInCategory = todoDictionary[category] {
                let todo = todosInCategory[indexPath.row]
                cell.textLabel?.text = todo.name
                cell.detailTextLabel?.text = todo.description
            }

            return cell
        }

        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let categories = Array(todoDictionary.keys)
            return categories[section]
        }


     
}
