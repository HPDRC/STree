unit Dbf_Str;

interface

{$I Dbf_Common.inc}

var
  STRING_FILE_NOT_FOUND: string;
  STRING_VERSION: string;

  STRING_RECORD_LOCKED: string;
  STRING_KEY_VIOLATION: string;

  STRING_INVALID_DBF_FILE: string;
  STRING_FIELD_TOO_LONG: string;
  STRING_INVALID_FIELD_COUNT: string;

  STRING_INDEX_BASED_ON_UNKNOWN_FIELD: string;
  STRING_INDEX_BASED_ON_INVALID_FIELD: string;
  STRING_INVALID_INDEX_TYPE: string;
  STRING_CANNOT_OPEN_INDEX: string;
  STRING_TOO_MANY_INDEXES: string;
  STRING_INDEX_NOT_EXIST: string;
  STRING_NEED_EXCLUSIVE_ACCESS: string;

implementation

initialization

  STRING_FILE_NOT_FOUND               := 'Ouverture: fichier non trouvé: "%s"';
  STRING_VERSION                      := 'TDbf V%d.%d';

  STRING_RECORD_LOCKED                := 'Enregistrement verrouillé.';
  STRING_KEY_VIOLATION                := 'Violation de clé. (doublon dans un index).'+#13+#10+
                                         'Index: %s'+#13+#10+'Enregistrement=%d Cle=''%s''';

  STRING_INVALID_DBF_FILE             := 'fichier DBF invalide.';
  STRING_FIELD_TOO_LONG               := 'Valeur trop longue: %d caractères (ne peut dépasser %d).';
  STRING_INVALID_FIELD_COUNT          := 'Nombre de champs non valide: %d (doit être entre 1 et 4095).';

  STRING_INDEX_BASED_ON_UNKNOWN_FIELD := 'Index basé sur un champ inconnu "%s"';
  STRING_INDEX_BASED_ON_INVALID_FIELD := 'Impossible de contruire un index sur ce type de champ "%s"';
  STRING_INVALID_INDEX_TYPE           := 'Type d''index non valide: doit être string ou float';
  STRING_CANNOT_OPEN_INDEX            := 'Impossible d''ouvrir l''index: "%s"';
  STRING_TOO_MANY_INDEXES             := 'Impossible de créer l''index: trop d''index dans le fichier.';
  STRING_INDEX_NOT_EXIST              := 'L''index "%s" n''existe pas.';
  STRING_NEED_EXCLUSIVE_ACCESS        := 'Access exclusif requis pour cette opération.';
end.

