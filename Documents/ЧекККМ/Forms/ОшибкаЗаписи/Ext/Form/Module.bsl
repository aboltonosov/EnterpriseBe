﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстСообщения = Параметры.ТекстСообщения;
	
	МассивДанных = Новый Массив;
	ДанныеДляЖурналаРегистрации = Параметры.ДанныеДляЖурналаРегистрации;
	Если ТипЗнч(ДанныеДляЖурналаРегистрации) = Тип("Структура") Тогда
		Для Каждого КлючИЗначение Из ДанныеДляЖурналаРегистрации Цикл
			МассивДанных.Добавить(Строка(КлючИЗначение.Ключ) + "=" + Строка(КлючИЗначение.Значение));
		КонецЦикла;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Розничные продажи'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,
		Параметры.Данные,
		ТекстСообщения + " " + НСтр("ru = 'Данные'")+ ":" + СтрСоединить(МассивДанных, ","));
	
КонецПроцедуры
