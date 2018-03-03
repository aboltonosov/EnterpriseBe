﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СоответствиеРеквизитов = Новый Соответствие;
	ТипЗначения = Параметры.ТипЗначения;
	ВыбранныеПоля.Загрузить(ПолучитьИзВременногоХранилища(Параметры.ДополнительныеПоля));
	
	Элементы.ВыбранныеПоляВОтдельнойКолонке.Видимость = Параметры.ЭтоСтроки;
	
	СКД = КомпоновкаДанныхСервер.ПустаяСхема();
	Набор = КомпоновкаДанныхСервер.ДобавитьПустойНаборДанных(СКД, Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	ФинансоваяОтчетностьСервер.НовоеПолеНабора(Набор, "Ссылка", "Ссылка", , ТипЗначения);
	
	Компоновщик = ФинансоваяОтчетностьСервер.КомпоновщикСхемы(СКД);
	ПоляСсылки = Компоновщик.Настройки.ДоступныеПоляВыбора.Элементы[0].Элементы;
	
	ПервыйСимвол = СтрДлина("Ссылка.") + 1;
	
	ПропускаемыеРеквизиты = "ПометкаУдаления, ВерсияДанных, ЭтоГруппа, Предопределенный,
							|ИмяПредопределенныхДанных";
	ПропускаемыеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПропускаемыеРеквизиты,,,Истина);
	
	Для Каждого ДоступноеПоле из ПоляСсылки Цикл
		Если ДоступноеПоле.Таблица Тогда
			Продолжить;
		КонецЕсли;
		ИмяРеквизита = Сред(ДоступноеПоле.Поле, ПервыйСимвол);
		Если ПропускаемыеРеквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ВыбранныеПоля.НайтиСтроки(Новый Структура("Реквизит", ИмяРеквизита)).Количество() Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ДоступныеПоля.Добавить();
		НоваяСтрока.Реквизит = ИмяРеквизита;
		НоваяСтрока.Наименование = Сред(ДоступноеПоле.Заголовок, ПервыйСимвол);
	КонецЦикла;
	
	ДоступныеПоля.Сортировать("Наименование");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Право(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент.Имя = "ДополнительныеПоляЗаголовок" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "ВыбранныеПоляВОтдельнойКолонке" Тогда
		Возврат;
	КонецЕсли;
	
	Лево(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПоместитьРезультатВХранилище());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Право(Команда)
	
	ТекущиеДанные = Элементы.ДоступныеПоля.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ВыбранныеПоля.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
	Элементы.ВыбранныеПоля.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
	ДоступныеПоля.Удалить(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Лево(Команда)
	
	ТекущиеДанные = Элементы.ВыбранныеПоля.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ДоступныеПоля.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
	Элементы.ДоступныеПоля.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	ДоступныеПоля.Сортировать("Наименование");
	
	ВыбранныеПоля.Удалить(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьРезультатВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ВыбранныеПоля.Выгрузить());
	
КонецФункции

#КонецОбласти

