﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация Бухгалтерии предприятия".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


// Обработчик события НачалоВыбора поля формы контактной информации.
// Вызывается из подключаемых действий при внедрении подсистемы "Контактная информация".
//
// Параметры:
//     Форма                - УправляемаяФорма - Форма владельца контактной информации.
//     Элемент              - ПолеФормы        - Элемент формы, содержащий представление контактной информации.
//     Модифицированность   - Булево           - Устанавливаемый флаг модифицированности формы.
//     СтандартнаяОбработка - Булево           - Устанавливаемый флаг стандартной обработки события формы.
//
Процедура НачалоВыбора(Форма, Элемент, Модифицированность = Истина, СтандартнаяОбработка = Ложь) Экспорт
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", Элемент.Имя);
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	
	// Если представление было изменено в поле и не соответствует реквизиту, то приводим в соответствие.
	Если Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
		Если ДанныеЗаполнения[Элемент.Имя] <> Элемент.ТекстРедактирования Тогда
			ДанныеЗаполнения[Элемент.Имя] = Элемент.ТекстРедактирования;
			УправлениеКонтактнойИнформациейКлиент.ПриИзменении(Форма, Элемент, ЭтоТабличнаяЧасть);
			Форма.Модифицированность = Истина;
		КонецЕсли;
		ТекстРедактирования = Элемент.ТекстРедактирования;
	Иначе 
		ТекстРедактирования = ?(ЗначениеЗаполнено(ДанныеСтроки.ЗначенияПолей), Форма[Элемент.Имя], "");
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ДанныеСтроки.Вид);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", ДанныеСтроки.ЗначенияПолей);
	ПараметрыОткрытия.Вставить("Представление", ТекстРедактирования);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	ПараметрыОткрытия.Вставить("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов", Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов);
	
	Если Не ЭтоТабличнаяЧасть Тогда
		ПараметрыОткрытия.Вставить("Комментарий", ДанныеСтроки.Комментарий);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеЗаполнения",  ДанныеЗаполнения);
	Оповещение.ДополнительныеПараметры.Вставить("ЭтоТабличнаяЧасть", ЭтоТабличнаяЧасть);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеСтроки",      ДанныеСтроки);
	Оповещение.ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",         Результат);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",             Форма);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия,, Оповещение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Завершение немодальных диалогов.

Процедура ПредставлениеНачалоВыбораЗавершение(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = ДополнительныеПараметры.ДанныеЗаполнения;
	НоваяСтрока      = ДополнительныеПараметры.ДанныеСтроки;
	Результат        = ДополнительныеПараметры.Результат;
	Элемент          = ДополнительныеПараметры.Элемент;
	Форма            = ДополнительныеПараметры.Форма;
	
	ТекстПредставления = РезультатЗакрытия.Представление;
	
	Если НоваяСтрока.Свойство("ХранитьИсториюИзменений") И НоваяСтрока.ХранитьИсториюИзменений Тогда
		КонтактнаяИнформацияОписаниеДополнительныхРеквизитов = ДанныеЗаполнения.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
		Отбор = Новый Структура("Вид", НоваяСтрока.Вид);
		НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		Для Каждого СтрокаКонтактнойИнформации Из НайденныеСтроки Цикл
			КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Удалить(СтрокаКонтактнойИнформации);
		КонецЦикла;
		
		Отбор = Новый Структура("Вид", НоваяСтрока.Вид);
		НайденныеСтроки = РезультатЗакрытия.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		ЭтоИсторическаяКонтактнаяИнформация = Ложь;
		ПоследниеЗначениеПолей = "";
		
		Для Каждого СтрокаКонтактнойИнформации Из НайденныеСтроки Цикл
			Если НЕ СтрокаКонтактнойИнформации.ЭтоИсторическаяКонтактнаяИнформация Тогда
				Если СтрСравнить(СтрокаКонтактнойИнформации.ЗначенияПолей, РезультатЗакрытия.КонтактнаяИнформация) <> 0 Тогда
					Если СтрокаКонтактнойИнформации.ДействуетС < НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()) Тогда
						// Контактная информация стала историей.
						НоваяКонтактнаяИнформация = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяКонтактнаяИнформация, СтрокаКонтактнойИнформации);
						НоваяКонтактнаяИнформация.ЭтоИсторическаяКонтактнаяИнформация = Истина;
						НоваяКонтактнаяИнформация.ИмяРеквизита= "";
					КонецЕсли;
						// Новая контактная информация.
						НоваяКонтактнаяИнформация = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяКонтактнаяИнформация, РезультатЗакрытия);
						НоваяКонтактнаяИнформация.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
						НоваяКонтактнаяИнформация.ДействуетС = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
						НоваяКонтактнаяИнформация.ИмяРеквизита = Элемент.Имя;
						НоваяКонтактнаяИнформация.ХранитьИсториюИзменений = Истина;
						НоваяКонтактнаяИнформация.ЭтоИсторическаяКонтактнаяИнформация = Ложь;
				Иначе
					НоваяКонтактнаяИнформация = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяКонтактнаяИнформация, СтрокаКонтактнойИнформации);
				КонецЕсли;
			Иначе
				НоваяКонтактнаяИнформация = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяКонтактнаяИнформация, СтрокаКонтактнойИнформации);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = РезультатЗакрытия.КонтактнаяИнформация;
		
	Иначе
		Если ПустаяСтрока(НоваяСтрока.Комментарий) И Не ПустаяСтрока(РезультатЗакрытия.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Истина);
			
		ИначеЕсли Не ПустаяСтрока(НоваяСтрока.Комментарий) И ПустаяСтрока(РезультатЗакрытия.Комментарий) Тогда
			Результат.Вставить("ЭтоДобавлениеКомментария", Ложь);
			
		Иначе
			Если Не ПустаяСтрока(НоваяСтрока.Комментарий) Тогда
				ЭлементКомментария = Форма.Элементы.Найти("Комментарий" + Элемент.Имя);
				Если ЭлементКомментария <> Неопределено Тогда
					ЭлементКомментария.Заголовок = РезультатЗакрытия.Комментарий;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		НоваяСтрока.Представление = ТекстПредставления;
		НоваяСтрока.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
		НоваяСтрока.Комментарий   = РезультатЗакрытия.Комментарий;
	КонецЕсли;
	
	Если РезультатЗакрытия.Свойство("АдресВВидеГиперссылки")
		И РезультатЗакрытия.АдресВВидеГиперссылки
		И НЕ ЗначениеЗаполнено(ТекстПредставления) Тогда
			ДанныеЗаполнения[Элемент.Имя] = УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки();
	Иначе
		ДанныеЗаполнения[Элемент.Имя] = ТекстПредставления;
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
	Форма.ПослеИзмененияКонтактнойИнформации(Результат);
	
	ОбновитьКонтактнуюИнформациюФормы(Форма, Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает строку дополнительных значений по имени реквизита.
//
// Параметры:
//    Форма   - УправляемаяФорма - передаваемая форма.
//    Элемент - ДанныеФормыСтруктураСКоллекцией - данные формы.
//
// Возвращаемое значение:
//    СтрокаКоллекции - найденные данные.
//    Неопределено    - при отсутствии данных.
//
Функция ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть = Ложь)
	
	Отбор = Новый Структура("ИмяРеквизита", Элемент.Имя);
	Строки = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	
	Если ЭтоТабличнаяЧасть И ДанныеСтроки <> Неопределено Тогда
		
		ПутьКСтроке = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		
		ДанныеСтроки.Представление = ПутьКСтроке[Элемент.Имя];
		ДанныеСтроки.ЗначенияПолей = ПутьКСтроке[Элемент.Имя + "ЗначенияПолей"];
		
	КонецЕсли;
	
	Возврат ДанныеСтроки;
	
КонецФункции

Функция ЭтоТабличнаяЧасть(Элемент)
	
	Родитель = Элемент.Родитель;
	
	Пока ТипЗнч(Родитель) <> Тип("УправляемаяФорма") Цикл
		
		Если ТипЗнч(Родитель) = Тип("ТаблицаФормы") Тогда
			Возврат Истина;
		КонецЕсли;
		
		Родитель = Родитель.Родитель;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Контекстный вызов
Процедура ОбновитьКонтактнуюИнформациюФормы(Форма, Результат)
	
	Форма.Подключаемый_ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

#КонецОбласти