# language: fr

Fonctionnalité: Modération des notes de frais
  En tant que manager
  Je veux modérer les notes de frais de mes collaborateurs
  Afin de les rembourser

  Scénario: Validation d'une note de frais
    Etant donné une note de frais soumise
    Lorsqu'il va dans l'espace des notes à modérer
    Alors la note de frais apparait
    Lorsqu'il la valide
    Alors celle-ci passe à l'état validée
  
  Scénario: Refus d'une note de frais
    Etant donné une note de frais soumise
    Lorsqu'il va dans l'espace des notes à modérer
    Alors la note de frais apparait
    Lorsqu'il la refuse
    Alors celle-ci passe à l'état refusée