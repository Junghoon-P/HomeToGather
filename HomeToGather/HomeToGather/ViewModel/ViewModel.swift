import SwiftUI
import Firebase
import FirebaseFirestore

class ViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    @Published var invitations = [Invitation(id: "", uid: "", organizerName: "", participantName: [""], participantUid: [""], title: "", date: "", place: "", description: "", rule: [""], cost: "", food: [""], etc: [""], ruleFeedback: [""], foodFeedback: [""], color: "")]
    @Published var userName = ""
    
    @Published var recentInvitation = Invitation(id: "", uid: "", organizerName: "", title: "Your Invited", date: "YY/MM/DD Time", place: "Hosted Address", description: "Home Party", rule: [""], cost: "", food: [""], etc: [""], color: "red")
    
    func uploadInvitation(_ invitation: Invitation) {
        
        let invitation = Invitation(id: invitation.id, uid: invitation.uid, organizerName: invitation.organizerName, participantName: invitation.participantName, participantUid: invitation.participantUid, title: invitation.title, date: invitation.date, place: invitation.place, description: invitation.description, rule: invitation.rule, cost: invitation.cost, food: invitation.food, etc: invitation.etc, ruleFeedback: [""], foodFeedback: [""], color: invitation.color)
        
        db.collection("ii").document(invitation.id).setData(invitation.dictionary)
    }
    
    func fetchInvitation() {
        db.collection("ii").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.invitations = documents.map({ (queryDocumentSnapshot) -> Invitation in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? "blank id"
                let uid = data["uid"] as? String ?? "blank uid"
                let organizerName = data["organizerName"] as? String ?? "blank organizerName"
                let participantName = data["participantName"] as? [String] ?? ["blank participantName"]
                let participantUid = data["paricipantUid"] as? [String] ?? ["blank paricipantUid"]
                let title = data["title"] as? String ?? "blank title"
                let date = data["date"] as? String ?? "blank date"
                let place = data["place"] as? String ?? "blank place"
                let description = data["description"] as? String ?? "blank description"
                let rule = data["rule"] as? [String] ?? ["blank rule"]
                let cost = data["cost"] as? String ?? "blank cost"
                let food = data["food"] as? [String] ?? ["blank food"]
                let etc = data["etc"] as? [String] ?? ["blank etc"]
                let ruleFeedback = data["ruleFeedback"] as? [String] ?? [""]
                let foodFeedback = data["foodFeedback"] as? [String] ?? [""]
                let color = data["color"] as? String ?? "blank color"
                return Invitation(id: id, uid: uid, organizerName: organizerName, participantName: participantName, participantUid: participantUid, title: title, date: date, place: place, description: description, rule: rule, cost: cost, food: food, etc: etc, ruleFeedback: ruleFeedback, foodFeedback: foodFeedback, color: color)
            })
        }
    }
    
    func fetchInvitationsSent(_ invitationUid: String) {
            db.collection("ii").order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                var sent = [Invitation(id: "", uid: "", organizerName: "", participantName: [""], participantUid: [""], title: "", date: "", place: "", description: "", rule: [""], cost: "", food: [""], etc: [""], ruleFeedback: [""], foodFeedback: [""], color: "")]
                sent = documents.map({ (queryDocumentSnapshot) -> Invitation in
                    if (queryDocumentSnapshot.data()["participantUid"] as? [String] ?? [""]).contains(invitationUid) {
                        let data = queryDocumentSnapshot.data()
                        let id = data["id"] as? String ?? "blank id"
                        let uid = data["uid"] as? String ?? "blank uid"
                        let organizerName = data["organizerName"] as? String ?? "blank organizerName"
                        let participantName = data["participantName"] as? [String] ?? ["blank participantName"]
                        let participantUid = data["participantUid"] as? [String] ?? ["blank participantUid"]
                        let title = data["title"] as? String ?? "blank title"
                        let date = data["date"] as? String ?? "blank date"
                        let place = data["place"] as? String ?? "blank place"
                        let description = data["description"] as? String ?? "blank description"
                        let rule = data["rule"] as? [String] ?? ["blank rule"]
                        let cost = data["cost"] as? String ?? "blank cost"
                        let food = data["food"] as? [String] ?? ["blank food"]
                        let etc = data["etc"] as? [String] ?? ["blank etc"]
                        let ruleFeedback = data["ruleFeedback"] as? [String] ?? [""]
                        let foodFeedback = data["foodFeedback"] as? [String] ?? [""]
                        let color = data["color"] as? String ?? "blank color"
                        return Invitation(id: id, uid: uid, organizerName: organizerName, participantName: participantName, participantUid: participantUid, title: title, date: date, place: place, description: description, rule: rule, cost: cost, food: food, etc: etc, ruleFeedback: ruleFeedback, foodFeedback: foodFeedback, color: color)
                    } else {
                        return Invitation(id: "", uid: "", organizerName: "", title: "", date: "", place: "", description: "", rule: [""], cost: "", food: [""], etc: [""], ruleFeedback: [""], foodFeedback: [""], color: "")
                    }
                })
                
                self.invitations = sent.filter { $0.id != "" }
                
                if !self.invitations.isEmpty {
                    self.recentInvitation = self.invitations[0]
                }
            }
        }
    
    func getInvitationsSent(_ invitationUid: String) {
        db.collection("ii").order(by: "date", descending: true).getDocuments(){ (querySnapshot, error) in

            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            var sent = [Invitation(id: "", uid: "", organizerName: "", participantName: [""], participantUid: [""], title: "", date: "", place: "", description: "", rule: [""], cost: "", food: [""], etc: [""], ruleFeedback: [""], foodFeedback: [""], color: "")]
            sent = documents.map({ (queryDocumentSnapshot) -> Invitation in
                if (queryDocumentSnapshot.data()["participantUid"] as? [String] ?? [""]).contains(invitationUid) {
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? "blank id"
                    let uid = data["uid"] as? String ?? "blank uid"
                    let organizerName = data["organizerName"] as? String ?? "blank organizerName"
                    let participantName = data["participantName"] as? [String] ?? ["blank participantName"]
                    let participantUid = data["participantUid"] as? [String] ?? ["blank participantUid"]
                    let title = data["title"] as? String ?? "blank title"
                    let date = data["date"] as? String ?? "blank date"
                    let place = data["place"] as? String ?? "blank place"
                    let description = data["description"] as? String ?? "blank description"
                    let rule = data["rule"] as? [String] ?? ["blank rule"]
                    let cost = data["cost"] as? String ?? "blank cost"
                    let food = data["food"] as? [String] ?? ["blank food"]
                    let etc = data["etc"] as? [String] ?? ["blank etc"]
                    let ruleFeedback = data["ruleFeedback"] as? [String] ?? [""]
                    let foodFeedback = data["foodFeedback"] as? [String] ?? [""]
                    let color = data["color"] as? String ?? "blank color"
                    return Invitation(id: id, uid: uid, organizerName: organizerName, participantName: participantName, participantUid: participantUid, title: title, date: date, place: place, description: description, rule: rule, cost: cost, food: food, etc: etc, ruleFeedback: ruleFeedback, foodFeedback: foodFeedback, color: color)
                } else {
                    return Invitation(id: "", uid: "", organizerName: "", title: "", date: "", place: "", description: "", rule: [""], cost: "", food: [""], etc: [""], ruleFeedback: [""], foodFeedback: [""], color: "")
                }
            })

            self.invitations = sent.filter { $0.id != "" }

            if !self.invitations.isEmpty {
                self.recentInvitation = self.invitations[0]
            }
        }
    }
    
    func correctionInvitation(_ invitation: Invitation, _ id: String) {
        var modified = invitation
        modified.id = id
        db.collection("ii").document(id).setData(modified.dictionary)
    }
    
    func correctionRuleFeedback(_ invitation: Invitation,_ ruleFeedback: String) {
        var correctionInvitation = invitation
        var feedback: [String] = invitation.ruleFeedback
        feedback.append(ruleFeedback)
        correctionInvitation.ruleFeedback = feedback
        db.collection("ii").document(invitation.id).setData(correctionInvitation.dictionary)
    }
    
    func correctionFoodFeedback(_ invitation: Invitation,_ foodFeedback: String) {
        var correctioinInvitation = invitation
        var feedback: [String] = invitation.foodFeedback
        feedback.append(foodFeedback)
        correctioinInvitation.foodFeedback = feedback
        db.collection("ii").document(invitation.id).setData(correctioinInvitation.dictionary)
    }
    
    func deleteInvitation(_ invitationId: String) {
        let _ = db.collection("ii").document(invitationId).delete()
    }
    
    func getUserName(_ uid: String) {
        let ref = db.collection("user").document(uid)
        ref.getDocument { document, error in
            if let error = error as NSError? {
                print("please god\(error)")
            }
            else {
                if let document = document {
                    let data = document.data()
                    let name = data?["name"] as? String ?? "no name"
                    self.userName = name
                }
            }
        }
    }
    
    // Deeplink
    // ID 값으로 Invitation 구조체 생성해 전달
    func findInvitation(id: String, _ completion: @escaping (_ data: Invitation?) -> Void ) {
        let docRef = Firestore.firestore().collection("ii").document(id)
                
        var newInvitation: Invitation?

        let g = DispatchGroup()
        g.enter()
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
    
                newInvitation = Invitation(id: document["id"] as? String ?? "empty",
                                        uid: document["uid"] as? String ?? "empty",
                                        organizerName: document["organizerName"] as? String ?? "empty",
                                        participantName: document["participantName"] as? [String] ?? [],
                                        participantUid: document["participantUid"] as? [String] ?? [],
                                        title: document["title"] as? String ?? "empty",
                                        date: document["date"] as? String ?? "empty",
                                        place: document["place"] as? String ?? "empty",
                                        description: document["description"] as? String ?? "empty",
                                        rule: document["rule"] as? [String] ?? [],
                                        cost: document["cost"] as? String ?? "empty",
                                        food: document["food"] as? [String] ?? [],
                                        etc: document["etc"] as? [String] ?? [],
                                        ruleFeedback: document["ruleFeedback"] as? [String] ?? [],
                                        foodFeedback: document["foodFeedback"] as? [String] ?? [],
                                        color: document["color"] as? String ?? "empty")
                
                g.leave()
                
            } else {
                print("Document does not exist")
                completion(nil)
                g.leave()
            }
        }
        
        g.notify(queue:.main) {
            completion(newInvitation)
        }
        
        return
    }
}

func getUserUid() -> String {
    guard let user = Auth.auth().currentUser else { return "" }
    return user.uid
}
