# language: fr

Fonctionnalité: Déclaration d'une note de frais
  En tant que collaborateur
  Je veux poster une demande de frais
  Afin de me faire rembourser 

  Une note de frais peut avoir 5 états: A soumettre, En attente de validation, Validée, Refusée, Annulée.
  Une note à soumettre peut être modifiée et soumise.
  Une note en attente de soumission ne peut plus être modifiée par le collaborateur et ne peut être qu'annulée.
  Une note validée ne peut plus être modifiée par personne et peut être téléchargée au format PDF.
  Une note refusée ou annulée ne peut plus être modifiée.
  
  Contexte:
    Etant donné un utilisateur connecté

  Scénario: Déclaration d'une note de frais
    Etant donné une categorie de fras
    Lorsqu'il va dans l'espace de notes de frais
    Et il déclare un frais
    Et il saisit le nom et la date de la note de frais puis valide
    Alors la note de frais est créée
    Et il déclare une ligne de frais
    Et il saisit les informations de la ligne de frais puis valide
    Alors la ligne de frais est créée
    Et le statut est à 'A soumettre'

  Scénario: Edition d'une note de frais 
    Etant donné une note de frais 
    Lorsqu'il va sur le détail de la note de frais
    Et il modifie la note
    Alors la modification de la note est prise en compte

  Scénario: Edition d'une ligne de frais 
    Etant donné une note de frais 
    Lorsqu'il va sur le détail de la note de frais
    Et il modifie une ligne de la note
    Alors la modification de la ligne est prise en compte

  Scénario: Soumission d'une note de frais
    Etant donné une note de frais 
    Lorsqu'il va sur la liste des notes de frais
    Alors il voit sa note
    Lorsqu'il soumet sa note de frais
    Alors la note de frais passe à l'état 'En attente de validation'

  Scénario: Annulation d'une note de frais
    Etant donné une note de frais 
    Lorsqu'il va sur la liste des notes de frais
    Alors il voit sa note
    Et il annule la note de frais
    Alors celle-ci passe à l'état annulée