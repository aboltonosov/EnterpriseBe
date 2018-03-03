﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаСервере
Перем КонтекстЭДОСервер Экспорт;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Заголовок = "Протокол " + Параметры.ИмяФайла;
	
	СообщениеПротокол = Параметры.СообщениеПротокол;
	
	// считываем текст из файла уведомления
	Попытка
		ПутьКФайлу = ПолучитьИмяВременногоФайла();
		ПолучитьИзВременногоХранилища(Параметры.Протокол).Записать(ПутьКФайлу);
		ЧтениеТекста = Новый ЧтениеТекста;
		КонтекстЭДОСервер.ЧтениеТекстаОткрытьНаСервере(ЧтениеТекста, ПутьКФайлу);
		СтрокаXML = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПутьКФайлу); // xml-файл
	Исключение
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка чтения содержимого подтверждения из файла: %1'"), Символы.ПС + Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецПопытки;
	
	// загружаем XML из строки в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML);
	Если ДеревоXML = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// определяем дату-время получения
	УзлыДатаВремяОтправки = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "датаВремяОтправки", "Э"), Истина);
	Если УзлыДатаВремяОтправки.Количество() = 0 Тогда
		ДатаВремяОтправки = "";
	Иначе
		ДатаВремяОтправки = Формат(ДатаВремяИзСтрокиXML(УзлыДатаВремяОтправки[0].Значение), "ДЛФ=DDT; ДП=-");
	КонецЕсли;
	
	// получаем признак того, что протокол положительный
	УзлыЗапросОбработанУспешно = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "запросОбработанУспешно", "Э"), Истина);
	Если УзлыЗапросОбработанУспешно.Количество() = 0 Тогда
		ОтветЯвляетсяПоложительным = "";
	Иначе
		ЗначениеСтр = УзлыЗапросОбработанУспешно[0].Значение;
		ЗначениеБулево = XMLЗначение(Тип("Булево"), ЗначениеСтр);
		ОтветЯвляетсяПоложительным = ?(ЗначениеБулево, "Да", "Нет");
		Если НЕ ЗначениеБулево Тогда
			Элементы.НадписьОтветЯвляетсяПоложительным.ЦветТекста = Новый Цвет(255, 0, 0);
		КонецЕсли;
	КонецЕсли;
	
	// находим узел "протокол"
	УзелОтвет = ДеревоXML.Строки.Найти("ответ", "Имя");
	Если УзелОтвет <> Неопределено Тогда
	
		// находим информацию о приложениях в XML
		УзлыСписокПриложений = УзелОтвет.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "списокПриложений", "Э"));
		Если УзлыСписокПриложений.Количество() > 0 Тогда
			
			УзелСписокПриложений = УзлыСписокПриложений[0];
			
			// перебираем приложения
			УзлыПриложение = УзелСписокПриложений.Строки.НайтиСтроки(Новый Структура("Имя", "приложение"));
			Если УзлыПриложение.Количество() > 0 Тогда
				
				Для Каждого УзелПриложение Из УзлыПриложение Цикл
					
					СтрПриложение = Приложения.ПолучитьЭлементы().Добавить();
					
					// находим подчиненный узел имяФайла
					УзелИмяФайла = УзелПриложение.Строки.Найти("имяФайла");
					Если УзелИмяФайла <> Неопределено Тогда
						СтрПриложение.Имя = УзелИмяФайла.Значение;
					КонецЕсли;
					
					// находим подчиненный узел идентификаторДокумента
					УзелИдентификаторДокумента = УзелПриложение.Строки.Найти("идентификаторДокумента");
					Если УзелИдентификаторДокумента <> Неопределено Тогда
						СтрПриложение.Идентификатор = УзелИдентификаторДокумента.Значение;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяФайлаДокумента = Элемент.ТекущиеДанные.Имя;
	
	Вложение = ПолучитьСтрокуВложенияНаСервере(СообщениеПротокол, ИмяФайлаДокумента);
	Если Вложение.Свойство("Предупреждение") Тогда 
		ПоказатьПредупреждение(, Вложение.Предупреждение);
		Возврат;
	КонецЕсли;
	КонтекстЭДОКлиент.ПоказатьПриложениеКОтветуНаЗапросПФР(Вложение);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДатаВремяИзСтрокиXML(ЗначениеСтр)
	
	Попытка
		Возврат XMLЗначение(Тип("Дата"), ЗначениеСтр);
	Исключение
		Возврат '00010101';
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Функция ПолучитьСтрокуВложенияНаСервере(СообщениеПротокол, ИмяФайлаДокумента)
	
	Возврат КонтекстЭДОКлиент.ПолучитьСтрокуВложенияНаСервере(СообщениеПротокол, ИмяФайлаДокумента);
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти

