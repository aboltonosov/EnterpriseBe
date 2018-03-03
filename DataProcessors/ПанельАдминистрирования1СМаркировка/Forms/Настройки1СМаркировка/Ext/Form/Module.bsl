﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ОбновитьВерсии();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетМаркировкиПродукцииВГИСМ(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаОбменаГИСМ(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОбменаГИСМ",,ЭтотОбъект,,ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОрганизацииДляОбменаГИСМ(Команда)
	
	ОткрытьФорму("РегистрСведений.ОрганизацииДляОбменаГИСМ.ФормаСписка",,ЭтотОбъект,,ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуПолучениеГИСМ(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОтправкиПолученияГИСМ", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОтправкиПолученияГИСМ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВерсию(Команда)
	
	ПроверитьВерсиюНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьВерсиюНаСервере()
	
	НоваяВерсия = ИнтеграцияГИСМВызовСервера.АктуальнаяВерсияСхемОбмена();
	
	Если ЗначениеЗаполнено(НоваяВерсия) Тогда
		ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(НоваяВерсия);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить версию сервера ГИСМ, возможно, требуется обновление конфигурации.'"));
	КонецЕсли;
	
	ОбновитьВерсии();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОтправкиПолученияГИСМ(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОтправкиПолученияГИСМ = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("ОтправкаПолучениеДанныхГИСМ", РасписаниеОтправкиПолученияГИСМ);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно) Экспорт
	
	РасписаниеАктивно = Ложь;
	
	Если Задание = Неопределено Тогда
		
		ТекстРасписания = НСтр("ru = '<Расписание не задано>'");
		
	Иначе
		
		Если Задание.Использование Тогда
			РасписаниеАктивно = Истина;
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание: %1'"), Строка(Задание.Расписание));
		Иначе
			ТекстРасписания = СтрШаблон(НСтр("ru = 'Расписание (НЕ АКТИВНО): %1'"), Строка(Задание.Расписание));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОтправкаПолучениеДанныхГИСМ");
	ЗаданиеОтправкаПолучениеДанныхГИСМ = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	РасписаниеОтправкиПолученияГИСМ = ЗаданиеОтправкаПолучениеДанныхГИСМ.Расписание;
	
	Элементы.ОтправкаПолучениеДанныхГИСМ.Доступность = ЗаданиеОтправкаПолучениеДанныхГИСМ.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОтправкаПолучениеДанныхГИСМ, Элементы.ОтправкаПолучениеДанныхГИСМ);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания, РасписаниеАктивно;
	
	ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		//++ НЕ ГИСМ
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		//-- НЕ ГИСМ
		
	КонецЕсли;
	
	Если КонстантаИмя = "ВестиУчетМаркировкиПродукцииВГИСМ"
		И Не КонстантаЗначение Тогда
		ИзменитьИспользованиеЗадания("ОтправкаПолучениеДанныхГИСМ", Ложь);
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ" Тогда
		ИзменитьИспользованиеЗадания("ОтправкаПолучениеДанныхГИСМ", НаборКонстант.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетМаркировкиПродукцииВГИСМ;
		
	//++ НЕ ГИСМ
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетМаркировкиПродукцииВГИСМ, ЗначениеКонстанты);
	//-- НЕ ГИСМ
		
	КонецЕсли;
	
	ВестиУчетМаркировкиПродукцииВГИСМ = ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ");
	
	Элементы.НастройкаОрганизацииДляОбменаГИСМ.Доступность                           = ВестиУчетМаркировкиПродукцииВГИСМ;
	Элементы.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ.Доступность = ВестиУчетМаркировкиПродукцииВГИСМ;
	Элементы.ОтправкаПолучениеДанныхГИСМ.Доступность                           = ВестиУчетМаркировкиПродукцииВГИСМ;
	Элементы.НастройкаОбменаГИСМ.Доступность                                   = ВестиУчетМаркировкиПродукцииВГИСМ;
	Элементы.ПроверитьВерсию.Доступность                                       = ВестиУчетМаркировкиПродукцииВГИСМ;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ГруппаГИСМНастройкиОбщая.Видимость = Ложь;
	Иначе
		УстановитьНастройкиЗаданий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, содержащую ключи, имеющиеся в обеих исходных структурах.
//
Функция ПолучитьОбщиеКлючиСтруктур(Структура1, Структура2) Экспорт
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьВерсии()
	
	ВерсииСхемОбмена = ИнтеграцияГИСМ.ВерсииСхемОбмена();
	
	ВерсияАктуальна = (ВерсииСхемОбмена.Клиент = ВерсииСхемОбмена.Сервер);
	
	Если Не ВерсияАктуальна Тогда
		ТекстСообщенияОВерсии = СтрШаблон(НСтр("ru = 'Текущая версия конфигурации не поддерживает актуальный формат обмена с ГИСМ (%1)'"), ВерсииСхемОбмена.Сервер);
	Иначе
		ТекстСообщенияОВерсии = СтрШаблон(НСтр("ru = 'Обмен с ГИСМ выполняется с использованием актуального формата обмена (%1)'"), ВерсииСхемОбмена.Сервер);
		ВерсияАктуальна = Истина;
	КонецЕсли;
	
	Элементы.ДекорацияВниманиеТребуетсяОбновлениеКонфигурации.Видимость = Не ВерсияАктуальна;
	
КонецПроцедуры

#КонецОбласти
