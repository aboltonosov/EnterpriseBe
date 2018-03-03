﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтатусВыполненнойЗагрузки = Ложь;
	// Устанавливаем текущую таблицу переходов
	ПереходыПоСценарию();
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИмяФайлаМоделиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИмяФайлаМоделиРасширениеПодключено",
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ЗавершитьФоновоеЗадание(ИдентификаторЗадания);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазделИнициализацииПереходовПомощника

&НаКлиенте
Функция ПараметрыПерехода()
	
	ПараметрыПерехода = Новый Структура;
	ПараметрыПерехода.Вставить("ПорядковыйНомерПерехода", "");
	ПараметрыПерехода.Вставить("ИмяОсновнойСтраницы", "");
	ПараметрыПерехода.Вставить("ИмяСтраницыНавигации", "");
	ПараметрыПерехода.Вставить("ИмяСтраницыДекорации", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриОткрытии", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПослеОткрытия", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриПереходеДалее", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриПереходеНазад", "");
	
	Возврат ПараметрыПерехода;
	
КонецФункции

&НаКлиенте
Процедура ПереходыПоСценарию()
	
	Переходы.Очистить();
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 1;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаПриветствие";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииНачало";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииНачало";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаПриветствие_ПриОткрытии";
	ПараметрыПерехода.ИмяОбработчикаПриПереходеДалее = "СтраницаПриветствие_ПриПереходеДалее";
	ДобавитьПереход(ПараметрыПерехода);
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 2;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаОжидания";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииОжидание";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииОжидание";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаОжидания_ПриОткрытии";
	ПараметрыПерехода.ИмяОбработчикаПослеОткрытия = "СтраницаОжидания_ПослеОткрытия";
	ДобавитьПереход(ПараметрыПерехода);
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 3;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаЗавершение";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииОкончание";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииОкончание";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаЗавершение_ПриОткрытии";
	ДобавитьПереход(ПараметрыПерехода);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПереход(ПараметрыПерехода)
	
	НоваяСтрока = Переходы.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПараметрыПерехода.ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ПараметрыПерехода.ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ПараметрыПерехода.ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ПараметрыПерехода.ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ПараметрыПерехода.ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ПараметрыПерехода.ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ПараметрыПерехода.ИмяОбработчикаПриОткрытии;
	НоваяСтрока.ИмяОбработчикаПослеОткрытия    = ПараметрыПерехода.ИмяОбработчикаПослеОткрытия;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	ПорядковыйНомерПерехода = Значение;
	Если ПорядковыйНомерПерехода < 0 Тогда
		ПорядковыйНомерПерехода = 0;
	КонецЕсли;
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
			КонецПопытки;
			
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
			КонецПопытки;
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Попытка
			Выполнить(ИмяПроцедуры);
		Исключение
		КонецПопытки;
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПропуститьСтраницу Тогда
			Если ЭтоПереходДалее Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			Иначе
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка отображения текущей страницы
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	ПодключитьОбработчикОжидания("ВыполнитьОбработчикПослеОткрытия", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикПослеОткрытия()
	
	СтрокиПереходаТекущие = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];

	// обработчик ПослеОткрытия
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПослеОткрытия) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика]()";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПослеОткрытия);
		
		Попытка
			Выполнить(ИмяПроцедуры);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РазделОбработчиковСобытийПерехода

&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриПереходеДалее(Отказ)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(СокрЛП(Объект.ИмяФайлаМодели)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан путь к файлу с данными'"), , "ИмяФайлаМодели", "ИмяФайлаМодели", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаЗавершение_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
	Элементы.НадписьСтатусЗагрузки.Заголовок =
		?(СтатусВыполненнойЗагрузки,
			НСтр("ru = 'Выгрузка успешно завершена'"),
			НСтр("ru = 'Выгрузка выполненна с ошибками'"));
			
	Элементы.НадписьВариантовПродолжения.Заголовок = 
		?(СтатусВыполненнойЗагрузки,
			НСтр("ru = 'Нажмите кнопку ""Готово"" для выхода из помощника.'"),
			НСтр("ru = 'Для того чтобы попробовать загрузить еще раз, нажмите ""Назад"", для выхода из помощника, нажимите ""Готово""'"));
	
	ЗаполнитьИтоговуюИнформацию();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если Не ЭтоПереходДалее Тогда
		
		ПропуститьСтраницу = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПослеОткрытия()
	
	Результат = ВыгрузитьНаСервере();
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);	
	Иначе
		ЗаписатьРезультат();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ВыгрузитьНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.ВыгрузитьМодельУчета(ПараметрыЗадания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Иначе
		
		НаименованиеЗадания = "";
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"Обработки.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.ВыгрузитьМодельУчета",
				ПараметрыЗадания,
				НаименованиеЗадания);
				
		АдресХранилища = Результат.АдресХранилища;
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИтоговуюИнформацию()
	
	ЕстьОшибки = Не СтатусВыполненнойЗагрузки;
	
	Элементы.ИтоговаяИнформация.Видимость = ЕстьОшибки;
	Если ЕстьОшибки Тогда
		ИтоговаяИнформация =  НСтр("ru = 'Протокол:'") + Символы.ПС + ПротоколОбмена.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ЗавершитьФоновоеЗадание(ИдентификаторЗадания)
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.Отменить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
		ЗаписатьРезультат();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗадания", 
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРезультат()
	
	РезультатВыгрузкиИзФайла = ПолучитьИзВременногоХранилища(АдресХранилища);
	СтатусВыполненнойЗагрузки = РезультатВыгрузкиИзФайла.ЗагрузкаВыполнена;
	Если СтатусВыполненнойЗагрузки Тогда
		РезультатВыгрузкиИзФайла.ФайлВыгрузки.Записать(Объект.ИмяФайлаМодели);
	Иначе
		ПротоколОбмена.УстановитьТекст(РезультатВыгрузкиИзФайла.ПротоколОбмена);
	КонецЕсли;
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаМоделиРасширениеПодключено(Результат, ДополнительныеПараметры) Экспорт 
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр             = "Файл выгрузки (*.xml)|*.xml";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок 		   = НСтр("ru = 'Выберите путь к файлу выгрузки модели учета'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИмяФайлаМоделиПоказатьДиалогЗавершение",
		ЭтотОбъект);
		
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаМоделиПоказатьДиалогЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИмяФайлаМодели = ВыбранныеФайлы[0];
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
