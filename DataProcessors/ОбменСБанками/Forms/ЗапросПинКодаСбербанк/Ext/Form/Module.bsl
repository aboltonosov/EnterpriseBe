﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НомерКонтейнера = Сред(УчетнаяЗапись, 4, 1);

	СтруктураВозврата = Новый Структура("НомерКонтейнера, ПинКод", НомерКонтейнера, ПинКод);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти