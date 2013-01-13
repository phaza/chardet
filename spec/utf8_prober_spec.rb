# -*- encoding: utf-8 -*-

require 'UniversalDetector'

describe UniversalDetector::UTF8Prober, 'detect UTF-8' do

  it 'correctly detects text encoded as UTF-8' do
    text_to_detect = <<-END_OF_TEXT
Städte – vom prallen Leben bis zum verträumten Schlupfwinkel

Pulsierende Metropolen, architektonische Highlights, historische Sehenswürdigkeiten, quirlige Einkaufsmeilen,
romantische Fachwerkhäuser, schillerndes Nachtleben: Die Städte in Deutschland sind vielseitig.

Wer hätte es gewusst? In Deutschland gibt es mehr als 10.000 Städte zwischen Nordsee und Alpen.
Und jede hat ihren ganz eigenen Charakter. In den lebendigen Städten erleben Besucher kulturelle Events,
musikalische Veranstaltungen und hochkarätige Museen. Auch einmalige Zeitzeugnisse der Geschichte begeistern Besucher
immer wieder aufs Neue. Die größten Metropolen und am häufigsten besuchten Städte finden Interessierte in der Rubrik Magic Cities.

Deutschlands Städte warten jeden Tag darauf, neu entdeckt zu werden.
Egal, ob romantisches Plätzchen oder Großstadt-Flair – gehen Sie auf die Suche.
    END_OF_TEXT

    detected = UniversalDetector::chardet(text_to_detect.bytes.to_a)
    detected['encoding'].should eq('utf-8')
  end

end
