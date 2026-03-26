import 'package:query/query.dart';
import 'package:test/test.dart';

void main() {
  const graphqlUrl = 'http://localhost:8000/graphql/v1';
  const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE';
  late QueryGraphqlClient client;

  setUpAll(() {
    client = QueryGraphqlClient(
      url: graphqlUrl,
      defaultHeaders: {'apikey': anonKey, 'Authorization': 'Bearer $anonKey'},
    );
  });

  group('characters', () {
    test('allCharacters returns mapped character list from supabase', () async {
      // When
      final characters = await client.allCharacters();

      print(characters);

      // Then
      expect(characters, isA<List<CharacterDto>>());

      if (characters.isNotEmpty) {
        expect(characters, everyElement(isA<CharacterDto>()));

        final first = characters.first;
        expect(first.id, isNotEmpty);
        expect(first.name, isNotEmpty);
        expect(first.gender, isNotEmpty);
        expect(first.image, isNotEmpty);
        expect(Uri.tryParse(first.image)?.hasAbsolutePath, isTrue);
        expect(first.status, isA<CharacterStatus>());
      }
    });
  });
}
